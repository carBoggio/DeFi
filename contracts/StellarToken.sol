// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract StellarToken {
    // Variables públicas
    string public name = "StellarToken";
    string public symbol = "ST";
    uint8 public decimals = 18; // Decimales estándar
    uint256 public totalSupply = 10 **24; // Cantidad de tokens que vamos a crear

    // Evento para la transferencia de tokens de un lugar a otro
    // Direccion indexada para poder realizar filtros

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value
    );

    event Approval (
        address indexed _owner,
        address indexed _spender,
        uint value
    );

    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance ;

    constructor(){
        balanceOf[msg.sender] = totalSupply;
    }



    function approve(address _spender, uint _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }






    // Transferencia de tokens:
    function transfer(address _to, uint _value) public  returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }





    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
         require(_value <= balanceOf[_from]);
         require(_value <= allowance[_from][msg.sender]);
         balanceOf[_from] -= _value;
         balanceOf[_to] += _value;
         allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true; 
    }



}