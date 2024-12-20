// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTFoodCombiner is ERC1155, Ownable {
    // Map para almacenar el supply de cada NFT
    mapping(uint256 => uint256) public supplies;

    // IDs de los ingredientes y platos finales
    uint256 public constant WATER = 1;
    uint256 public constant LEMON = 2;
    uint256 public constant SUGAR = 3;
    uint256 public constant SACCHARINE = 4;
    uint256 public constant PASTA = 5;
    uint256 public constant TOMATO = 6;
    uint256 public constant LEMONADE = 7;
    uint256 public constant PASTA_WITH_TOMATO = 8;

    constructor() 
        ERC1155("https://raw.githubusercontent.com/Cisternita/p4Tokens/refs/heads/main/data.json") 
        Ownable(msg.sender) 
    {}

    function mint(uint256 id, uint256 amount) public onlyOwner {
        supplies[id] += amount;
        _mint(msg.sender, id, amount, "");
    }

    function combineForLemonade(
        uint256 waterAmount,
        uint256 lemonAmount,
        uint256 sweetenerAmount,
        bool diabetic
    ) public {
        uint256 sweetener = diabetic ? SACCHARINE : SUGAR;

        require(balanceOf(msg.sender, WATER) >= waterAmount, "Not enough water");
        require(balanceOf(msg.sender, LEMON) >= lemonAmount, "Not enough lemon");
        require(balanceOf(msg.sender, sweetener) >= sweetenerAmount, "Not enough sweetener");

        _burn(msg.sender, WATER, waterAmount);
        _burn(msg.sender, LEMON, lemonAmount);
        _burn(msg.sender, sweetener, sweetenerAmount);

        _mint(msg.sender, LEMONADE, 1, "");
    }

    function combineForPastaWithTomato() public {
        require(balanceOf(msg.sender, PASTA) >= 1, "Not enough pasta");
        require(balanceOf(msg.sender, TOMATO) >= 1, "Not enough tomato");
        require(balanceOf(msg.sender, WATER) >= 1, "Not enough water");

        _burn(msg.sender, PASTA, 1);
        _burn(msg.sender, TOMATO, 1);
        _burn(msg.sender, WATER, 1);

        _mint(msg.sender, PASTA_WITH_TOMATO, 1, "");
    }
}
