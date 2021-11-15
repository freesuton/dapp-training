// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {

    // 2 players in the game and each of them make a choice
    address payable private player1;
    address payable private player2;
    string private choiceofPlayer1;
    string private choiceofPlayer2;
    bool private hasPlayer1MadeChoice;
    bool private hasPlayer2MadeChoice;

    //when a player join the game, he has to pay fee;
    uint256 public stake;

    mapping(string => mapping(string => uint256)) private winner;

    constructor()  {
        winner['Rock']['Rock'] = 0;
        winner['Rock']['Paper'] = 2;
        winner['Rock']['Scissor'] = 1;
        winner['Paper']['Paper'] = 0;
        winner['Paper']['Scissor'] = 2;
        winner['Paper']['Rock'] = 1;
        winner['Scissor']['Scissor'] = 0;
        winner['Scissor']['Rock'] = 2;
        winner['Scissor']['Paper'] = 1;

        stake = 0.01 ether;
    }

    function join() external payable{
        //Determine whether there is a free space
        if(player1 == address(0)){
            player1 = payable(msg.sender);
            stake = msg.value;
        }else{
            player2 = payable(msg.sender);
        }

    }

    //value from external should be stored in calldata
    function makeChoice(string calldata _playerChoice) external {
        if(msg.sender == player1 && !hasPlayer1MadeChoice){
            choiceofPlayer1 = _playerChoice;
            hasPlayer1MadeChoice = true;
        }else if(msg.sender == player2 && !hasPlayer2MadeChoice){
            choiceofPlayer2 = _playerChoice;
            hasPlayer2MadeChoice = true;
        }

    }

    //show the result of game
    function showResult() external view returns(uint256){
        return winner[choiceofPlayer1][choiceofPlayer2];
    }

    //finish the game
    function finishGame() external payable{
        uint256 result = winner[choiceofPlayer1][choiceofPlayer2];
        if(result == 0){
            player1.transfer(stake);
            player2.transfer(stake);
        }else if(result == 1){
            player1.transfer(address(this).balance);
        }else if(result == 2){
            player2.transfer(address(this).balance);
        }

        //restart the game
        player1 = payable(address(0));
        player2 = payable(address(0));

        choiceofPlayer1 = "";
        choiceofPlayer2 = "";

        hasPlayer1MadeChoice = false;
        hasPlayer2MadeChoice = false;

        stake = 0.1 ether;

    }


    //test
    function test() external view returns(string memory){
        if(player1 == address(0)){
            return "a";
        }

        if(player1 == payable(address(0))){
            return "b";
        }else{
            return "c";
        }
    }

    function test2() external pure returns(uint256 ){
        return 1;
    }

    function TestView() external returns(uint256){
        choiceofPlayer1 = "Paper";
        choiceofPlayer2 = "Rock";
        return winner[choiceofPlayer1][choiceofPlayer2];

    }

    function testChoice() external view returns(string memory){
      return choiceofPlayer1;
    }


}