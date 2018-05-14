

//const Wrestling = artifacts.require("./Wrestling.sol")
const Escrow = artifacts.require("./Escrow.sol")


module.exports = function(deployer) {
    //deployer.deploy(Wrestling);
    deployer.deploy(Escrow);
};
