// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/eip/interface/IERC20.sol";
import "./ERC4907.sol";

contract ReadyGameThree is ERC4907 {
    constructor(
        string memory name_,
        string memory symbol_,
        address royaltyRecipient_,
        uint128 royaltyBps_
    ) ERC4907(name_, symbol_, royaltyRecipient_, royaltyBps_) {}

    address public constant tokenAddress =
        0x4fbc3E04046034Ac75530863f4822D94566c9d3D;

    uint256 public mintCost = 1e17;
    mapping(uint256 => uint256) public tokenLendingCost;

    function mintTo(address, string memory) public virtual override {
        require(false, "Not allowed");
    }

    function mint(
        address to,
        string memory _tokenURI,
        uint256 lendingCost
    ) public {
        address sender = msg.sender;
        require(
            IERC20(tokenAddress).transferFrom(sender, owner(), mintCost),
            "Could not transfer"
        );
        uint256 tokenId = nextTokenIdToMint();
        super.mintTo(to, _tokenURI);
        tokenLendingCost[tokenId] = lendingCost;
    }

    function setUser(
        uint256 tokenId,
        address user,
        uint64 expires
    ) public override {
        if (user != address(0)) {
            require(
                IERC20(tokenAddress).transferFrom(
                    user,
                    owner(),
                    tokenLendingCost[tokenId]
                ),
                "Could not transfer"
            );
        }

        super.setUser(tokenId, user, expires);
    }

    function setMintCost(uint256 cost) public onlyOwner {
        mintCost = cost;
    }

    function setTokenLendingCost(
        uint256 tokenId,
        uint256 cost
    ) public onlyOwner {
        tokenLendingCost[tokenId] = cost;
    }
}
