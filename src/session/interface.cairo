use controller::signer::signer_signature::{Signer, SignerSignature};
use poseidon::poseidon_hash_span;
use starknet::account::Call;
use starknet::{ContractAddress, get_contract_address, get_tx_info};

/// @notice Session struct that the owner and guardian has to sign to initiate a session
/// @dev The hash of the session is also signed by the guardian (backend) and
/// the dapp (session key) for every session tx (which may include multiple calls)
/// @param expires_at Expiry timestamp of the session (seconds)
/// @param allowed_methods_root The root of the merkle tree of the allowed methods
/// @param metadata_hash The hash of the metadata JSON string of the session
/// @param session_key_guid The GUID of the session key
/// @param guardian_key_guid The GUID of the session key
#[derive(Drop, Serde, Copy)]
struct Session {
    expires_at: u64,
    allowed_policies_root: felt252,
    metadata_hash: felt252,
    session_key_guid: felt252,
    guardian_key_guid: felt252,
}

/// @notice Session Token struct contains the session struct, relevant signatures and merkle proofs
/// @param session The session struct
/// @param cache_authorization Flag indicating whether to cache the authorization signature for the session
/// @param session_authorization A valid account signature over the Session
/// @param session_signature Session signature of the poseidon H(tx_hash, session hash)
/// @param guardian_signature Guardian signature of the poseidon H(tx_hash, session hash)
/// @param proofs The merkle proof of the session calls
#[derive(Drop, Serde, Copy)]
struct SessionToken {
    session: Session,
    cache_authorization: bool,
    session_authorization: Span<felt252>,
    session_signature: SignerSignature,
    guardian_signature: SignerSignature,
    proofs: Span<Span<felt252>>,
}

/// @param scope_hash Commitment computed as `poseidon(domain_separator_hash, type_hash)`
/// @param typed_data_hash Encoded data for the primary type as a single `felt252`
#[derive(Drop, Serde, Copy)]
struct TypedData {
    scope_hash: felt252,
    typed_data_hash: felt252,
}

#[derive(Drop, Serde, Copy)]
struct DetailedTypedData {
    domain_hash: felt252,
    type_hash: felt252,
    params: Span<felt252>,
}

#[derive(Drop, Serde, Copy)]
enum Policy {
    Call: Call,
    TypedData: TypedData,
}

#[derive(Drop, Serde, Copy, PartialEq)]
enum SessionState {
    NotRegistered,
    Revoked,
    Validated: felt252,
}

#[generate_trait]
impl SessionStateImpl of SessionStateTrait {
    fn from_felt(felt: felt252) -> SessionState {
        match felt {
            0 => SessionState::NotRegistered,
            1 => SessionState::Revoked,
            _ => SessionState::Validated(felt),
        }
    }
    fn into_felt(self: SessionState) -> felt252 {
        match self {
            SessionState::NotRegistered => 0,
            SessionState::Revoked => 1,
            SessionState::Validated(hash) => hash,
        }
    }
}

#[starknet::interface]
trait ISession<TContractState> {
    fn revoke_session(ref self: TContractState, session_hash: felt252);
    fn register_session(ref self: TContractState, session: Session, guid_or_address: felt252);
    fn is_session_revoked(self: @TContractState, session_hash: felt252) -> bool;
    fn is_session_registered(self: @TContractState, session_hash: felt252, guid_or_address: felt252) -> bool;
    fn is_session_signature_valid(self: @TContractState, data: Span<TypedData>, token: SessionToken) -> bool;
}

#[starknet::interface]
trait ISessionCallback<TContractState> {
    fn parse_authorization(self: @TContractState, authorization_signature: Span<felt252>) -> Array<SignerSignature>;
    fn is_valid_authorizer(self: @TContractState, guid_or_address: felt252) -> bool;
    fn verify_authorization(
        self: @TContractState, session_hash: felt252, authorization_signature: Span<SignerSignature>,
    );
}

