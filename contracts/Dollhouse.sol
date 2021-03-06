// //SPDX-License-Identifier: MIT
// //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)

// pragma solidity ^0.8.0;

// // @title: Dollhouse
// // @author: bimbotech
// /*

// 乃工爪乃龱 ㄒ㠪⼕廾

// ┊┊┊┊    @    @
// ┊┊┊   (✿ ͡◕ ᴗ◕)つ━━✫・*。
// ┊┊🌙 ☆  ⊂　　 ノ 　　　・゜+.
// ┊┊  * しーーＪ　　　°。+ *´¨)
// ┊☆ ° .· ´♥ 𝖜𝖊𝖑𝖈𝖔𝖒𝖊 𝖙𝖔 𝖙𝖍𝖊 𝖉𝖔𝖑𝖑𝖍𝖔𝖚𝖘𝖊 ♥ ☆´¨) ¸.·*¨)
// 🌙* (¸.·´ (¸.·’* (¸.·’* (¸.·’* (¸.·’* (¸.·’* *¨)
// .・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。.・。.・゜✭・.・✫・゜・。..・。.・゜✭・.・✫・゜・。.✭・.・✫・゜・。..・✫・゜・。
// */

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/interfaces/IERC2981.sol";
// import "@openzeppelin/contracts/interfaces/IERC20.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// contract Dollhouse is ERC721, IERC2981, Ownable, ReentrancyGuard {
//     using Counters for Counters.Counter;
//     using Strings for uint256;

//     Counters.Counter private tokenCounter;

//     string private baseURI;
//     string public verificationHash;
//     address private openSeaProxyRegistryAddress;
//     bool private isOpenSeaProxyActive = true;

//     uint256 public constant MAX_DOLLS_PER_WALLET = 5;
//     uint256 public maxDolls;

//     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
//     bool public isPublicSaleActive;

//     uint256 public maxGiftedDolls;
//     uint256 public numGiftedDolls;
//     bytes32 public claimListMerkleRoot;

//     mapping(address => bool) public claimed;

//     // ============ ACCESS CONTROL/SANITY MODIFIERS ============

//     modifier publicSaleActive() {
//         require(isPublicSaleActive, "Public sale is not open");
//         _;
//     }

//     modifier maxDollsPerWallet(uint256 numberOfTokens) {
//         require(
//             balanceOf(msg.sender) + numberOfTokens <= MAX_DOLLS_PER_WALLET,
//             "Max dolls to mint is five"
//         );
//         _;
//     }

//     modifier canMintDolls(uint256 numberOfTokens) {
//         require(
//             tokenCounter.current() + numberOfTokens <=
//                 maxDolls - maxGiftedDolls,
//             "Not enough dolls remaining to mint"
//         );
//         _;
//     }

//     modifier canGiftDolls(uint256 num) {
//         require(
//             numGiftedDolls + num <= maxGiftedDolls,
//             "Not enough dolls remaining to gift"
//         );
//         require(
//             tokenCounter.current() + num <= maxDolls,
//             "Not enough dolls remaining to mint"
//         );
//         _;
//     }

//     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
//         require(
//             price * numberOfTokens == msg.value,
//             "Incorrect ETH value sent"
//         );
//         _;
//     }

//     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
//         require(
//             MerkleProof.verify(
//                 merkleProof,
//                 root,
//                 keccak256(abi.encodePacked(msg.sender))
//             ),
//             "Address does not exist in list"
//         );
//         _;
//     }

//     constructor(
//         address _openSeaProxyRegistryAddress,
//         uint256 _maxDolls,
//         uint256 _maxGiftedDolls
//     ) ERC721("Dollhouse", "DOLL") {
//         openSeaProxyRegistryAddress = _openSeaProxyRegistryAddress;
//         maxDolls = _maxDolls;
//         maxGiftedDolls = _maxGiftedDolls;
//     }

//     // ============ PUBLIC FUNCTIONS FOR MINTING ============

//     function mint(uint256 numberOfTokens)
//         external
//         payable
//         nonReentrant
//         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
//         publicSaleActive
//         canMintDolls(numberOfTokens)
//         maxDollsPerWallet(numberOfTokens)
//     {
//         for (uint256 i = 0; i < numberOfTokens; i++) {
//             _safeMint(msg.sender, nextTokenId());
//         }
//     }

//     function claim(bytes32[] calldata merkleProof)
//         external
//         isValidMerkleProof(merkleProof, claimListMerkleRoot)
//         canGiftDolls(1)
//     {
//         require(!claimed[msg.sender], "Doll already claimed by this wallet");

//         claimed[msg.sender] = true;
//         numGiftedDolls += 1;

//         _safeMint(msg.sender, nextTokenId());
//     }


//     // ============ PUBLIC READ-ONLY FUNCTIONS ============

//     function getBaseURI() external view returns (string memory) {
//         return baseURI;
//     }

//     function getLastTokenId() external view returns (uint256) {
//         return tokenCounter.current();
//     }

//     // ============ OWNER-ONLY ADMIN FUNCTIONS ============

//     function setBaseURI(string memory _baseURI) external onlyOwner {
//         baseURI = _baseURI;
//     }

//     // function to disable gasless listings for security in case
//     // opensea ever shuts down or is compromised
//     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
//         external
//         onlyOwner
//     {
//         isOpenSeaProxyActive = _isOpenSeaProxyActive;
//     }

//     function setVerificationHash(string memory _verificationHash)
//         external
//         onlyOwner
//     {
//         verificationHash = _verificationHash;
//     }

//     function setIsPublicSaleActive(bool _isPublicSaleActive)
//         external
//         onlyOwner
//     {
//         isPublicSaleActive = _isPublicSaleActive;
//     }

//     function setClaimListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
//         claimListMerkleRoot = merkleRoot;
//     }

//     function reserveForGifting(uint256 numToReserve)
//         external
//         nonReentrant
//         onlyOwner
//         canGiftDolls(numToReserve)
//     {
//         numGiftedDolls += numToReserve;

//         for (uint256 i = 0; i < numToReserve; i++) {
//             _safeMint(msg.sender, nextTokenId());
//         }
//     }

//     function giftDolls(address[] calldata addresses)
//         external
//         nonReentrant
//         onlyOwner
//         canGiftDolls(addresses.length)
//     {
//         uint256 numToGift = addresses.length;
//         numGiftedDolls += numToGift;

//         for (uint256 i = 0; i < numToGift; i++) {
//             _safeMint(addresses[i], nextTokenId());
//         }
//     }

//     function withdraw() public onlyOwner {
//         uint256 balance = address(this).balance;
//         payable(msg.sender).transfer(balance);
//     }

//     function withdrawTokens(IERC20 token) public onlyOwner {
//         uint256 balance = token.balanceOf(address(this));
//         token.transfer(msg.sender, balance);
//     }

//     // ============ SUPPORTING FUNCTIONS ============

//     function nextTokenId() private returns (uint256) {
//         tokenCounter.increment();
//         return tokenCounter.current();
//     }

//     // ============ FUNCTION OVERRIDES ============

//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         virtual
//         override(ERC721, IERC165)
//         returns (bool)
//     {
//         return
//             interfaceId == type(IERC2981).interfaceId ||
//             super.supportsInterface(interfaceId);
//     }

//     /**
//      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
//      */
//     function isApprovedForAll(address owner, address operator)
//         public
//         view
//         override
//         returns (bool)
//     {
//         // Get a reference to OpenSea's proxy registry contract by instantiating
//         // the contract using the already existing address.
//         ProxyRegistry proxyRegistry = ProxyRegistry(
//             openSeaProxyRegistryAddress
//         );
//         if (
//             isOpenSeaProxyActive &&
//             address(proxyRegistry.proxies(owner)) == operator
//         ) {
//             return true;
//         }

//         return super.isApprovedForAll(owner, operator);
//     }

//     /**
//      * @dev See {IERC721Metadata-tokenURI}.
//      */
//     function tokenURI(uint256 tokenId)
//         public
//         view
//         virtual
//         override
//         returns (string memory)
//     {
//         require(_exists(tokenId), "Nonexistent token");

//         return
//             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
//     }

//     /**
//      * @dev See {IERC165-royaltyInfo}.
//      */
//     function royaltyInfo(uint256 tokenId, uint256 salePrice)
//         external
//         view
//         override
//         returns (address receiver, uint256 royaltyAmount)
//     {
//         require(_exists(tokenId), "Nonexistent token");

//         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
//     }
// }

// // These contract definitions are used to create a reference to the OpenSea
// // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
// contract OwnableDelegateProxy {

// }

// contract ProxyRegistry {
//     mapping(address => OwnableDelegateProxy) public proxies;
// }
