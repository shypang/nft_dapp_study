// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//다음과 같이 짧은 코드로 mint 함수를 만들수 있다. 
contract MintAnimalToken is ERC721Enumerable, ERC721URIStorage,Ownable {
    //constructor : 스마트컨트랙트가 빌드될 때 한번 실행함 
    // ERC721(name, symbol)
    constructor() ERC721("h662Animals","HAS"){}

    //앞 uint256은 animalTokenId 뒤 uint256은 animalTypes 
    mapping(uint256 => uint256) public animalTypes; 


  //오픈 제플린 라이브러리를 쓰고 상속할 경우 필수로 써야함
  //토큰 전송전 체크 
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 animalTokenId,
        uint256 batchSize
    ) internal  override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, animalTokenId,batchSize);
    }

  //오픈 제플린 라이브러리를 쓰고 상속할 경우 필수로 써야함
  //소각하는 함수 
        function _burn(
        uint256 animalTokenId
    ) internal
      override(ERC721, ERC721URIStorage) {
        super._burn(animalTokenId);
    }

  //오픈 제플린 라이브러리를 쓰고 상속할 경우 필수로 써야함
  //인터페이스 지원하는 함수 
   function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    

    function tokenURI(
    uint256 animalTokenId
    ) public view
      override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(animalTokenId);
    }
    
    function mintAnimalToken(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        //tokenid가 유일해야 NFT라고 할 수 있다. 
        uint256 animalTokenId = totalSupply() + 1;

        //솔리디티에서 랜덤은 다음과같이 만든다. 
        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 +1; 

        //배열에 값을 선언한다. 
        animalTypes[animalTokenId] = animalType; 

        //erc721에서 제공해주는 함수 _mint
        //msg.sender는 컨트랙트를 발행하는 사람, owner / animalTokenId는 NFT임을 증명하는 고유의 넘버 
        _mint(recipient, animalTokenId);
        //tokenURI : nft 이미지 주소 받는 곳, animalTokenId : NFT 아이디 
        _setTokenURI(animalTokenId, tokenURI);

           return animalTokenId;
        
    }
}