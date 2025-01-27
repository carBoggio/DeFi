// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "contracts/JamToken.sol";
import "contracts/StellarToken.sol";
// Owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// usuario: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2


contract TokenFarm {
    string name = "Stellar Token Farm";
    address public owner;
    JamToken public jamtoken;
    StellarToken public stellarToken;

    // Estrucutra de datos:
    // Array para las personas que hacen staking:
    address [] public stakers;
    mapping (address => uint) public stakingBalance;
    mapping (address => bool) public hasStaked;
    mapping (address => bool) public isStaking;


    constructor(StellarToken _stellarToken, JamToken _JamToken){
        jamtoken = _JamToken;
        stellarToken = _stellarToken;
        owner = msg.sender;
    }

    function stakeTokens(uint _amount) public {
        // La cantidad no puede ser menor a cero
        require(_amount > 0, "La cantidad no puede ser menor a cero");
        jamtoken.transferFrom(msg.sender, address(this), _amount);
        // Actualizar el saldo de staking:
        stakingBalance[msg.sender] += _amount;
        // Guardar el staking
        if (!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }
        // Actaulizando los valores del staking:
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;

    }

    function unStakeTokens() public {
        require(isStaking[msg.sender], "The user is not staking");    

        // Tomamos su balance
        uint balance = stakingBalance[msg.sender];
        require(balance > 0 );
        // Se lo transferimos
        jamtoken.transfer(msg.sender, balance);
        // Resetea el balance del staking del usuario:
        stakingBalance[msg.sender] = 0;
        // Y no esta haciendo staking:
        isStaking[msg.sender] = false;
    }

    // Emitir tokens y recompensas del staking:
    function issueTokens() public {
        require(msg.sender == owner);
        for (uint i = 0; i < stakers.length; i++ ){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0 ){
                stellarToken.transfer(recipient, balance);
            }
        }
    }



}





