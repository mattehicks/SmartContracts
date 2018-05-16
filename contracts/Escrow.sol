pragma solidity ^0.4.23;

contract EscrowToken{

    mapping (address => uint) balances;

    address contract_owner;
    address public seller;
    address public buyer;
    bool sellerApprove;
    bool buyerApprove;
    string public sellername;
    string public broker;
    uint256 public created;

    TokenCreator creator;
    address owner;
    bytes32 name;

    event escrowEvent1(address seller, address buyer);
    event verify(string message);

    constructor(bytes32 _name) public {
        contract_owner = msg.sender;
        //Returns the address of a new token
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function start(string name) returns (string){
        sellername = name;
        created = now;

        string memory message = "Event triggered--";
        emit verify(message);
        return "Contract started";
    }

    function setup(address seller,address  buyer){
        if(msg.sender == escrow){
            seller = seller;
            buyer = buyer;
        }

        //todo add date
        emit escrowEvent1(seller, buyer);
    }

    function transfer(address newOwner) public {
        // Only the current owner can transfer the token.
        if (msg.sender != owner) return;
        if (creator.isTokenTransferOK(owner, newOwner))
            owner = newOwner;
    }

    function approve(){
        if(msg.sender == buyer) buyerApprove = true;
        else if(msg.sender == seller) sellerApprove = true;
        if(sellerApprove && buyerApprove) fee();
    }

    function abort(){
        if(msg.sender == buyer) buyerApprove = false;
        else if (msg.sender == seller) sellerApprove = false;
        if(!sellerApprove && !buyerApprove) refund();
    }

    function payOut(){
        if(seller.send(this.balance)) balances[buyer] = 0;
    }

    function deposit(){
        if(msg.sender == buyer) balances[buyer] += msg.value;
        else revert();
    }

    function killContract() internal {
        selfdestruct(escrow);
        //kills contract and returns funds to buyer
    }

    function refund(){
        if(buyerApprove == false && sellerApprove == false) selfdestruct(buyer);
        //send money back to recipient if both parties agree contract is void
    }

    function fee(){
        escrow.send(this.balance / 100); //1% fee
        payOut();
    }

}

contract TokenCreator {
    function createToken(bytes32 name)
    public
    returns (EscrowToken tokenAddress)
    {
        return new EscrowToken(name);
    }

    function changeName(EscrowToken tokenAddress, bytes32 name)  public {
        // Again, the external type of `tokenAddress` is
        // simply `address`.
        tokenAddress.changeName(name);
    }

    function isTokenTransferOK(address currentOwner, address newOwner)
    public
    view
    returns (bool ok)
    {
        // Check some arbitrary condition.
        address tokenAddress = msg.sender;
        return (keccak256(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
    }
}