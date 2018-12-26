pragma solidity ^0.5.0;

contract Lottery {
    
    struct Player {
        bool is_value;
        address payable my_address;
    }
    
    struct Game {
        uint round_num;
        uint res;
        mapping(uint => Player) record;
    }
    
    uint round_num;

    uint public jackpot;
    
    uint public ticket_price;
    
    // 记录
    Game[] public all_games;

    // 用于慈善的钱数
    uint public money_for_charity;
    
    // 使用的
    address payable public trusted_manager;
    
    // uint represent the amount of money people can get
    mapping(address => uint) public registered_people_in_need;
    
    // getter
    function get_charity_money() public view returns(uint) {
        return money_for_charity;
    }


    modifier onlyByManager() {
        require(
            msg.sender == trusted_manager,
            "Sender not authorized."
        );
        _;
    }
    
    modifier onlyByRegisteredPeople() {
        require(
            registered_people_in_need[msg.sender] > 0,
            "Sender not authorized."
        );
        _;
    }
    
    modifier onlyValidTicketNumber(uint num) {
        require(
            num > 0,
            "invalid ticket number."
        );
        _;
    }
    
    modifier needGameRunning() {
        require(
            all_games[round_num].res == 0,
            "no running game. please wait for manager publish new game."
        );
        _;
    }
    
    event CongratulationToWinner(address winner, string description);
    
    event CreateNewGameSuccessfully(address manager, string description);


    constructor() public {
        trusted_manager = msg.sender;
        money_for_charity = 0;
        round_num = 0;
        ticket_price = 1 ether;
        // initial game
        all_games.push(Game({
            round_num: round_num, 
            res: 1
        }));
        
    }
    
    function new_game() public onlyByManager{
        round_num = round_num + 1;
        all_games.push(Game({
            round_num: round_num, 
            res: 0
        }));
        emit CreateNewGameSuccessfully(trusted_manager, "open new game!!");
    }
    
    function bet(uint prediction) public payable returns(bool) {
        // @params: id, 第几轮游戏
        // @params: prediction,  玩家压的注

        require(
            msg.sender != trusted_manager,
            "manager can't take part in this game.");
        require(
            msg.value == ticket_price,
            "value with the transaction must be equal to ticket price");
        require(
            all_games[round_num].record[prediction].is_value == false,
            "this number has been taken");
        if(all_games[round_num].record[prediction].is_value == false) {
            all_games[round_num].record[prediction].is_value = true;
            all_games[round_num].record[prediction].my_address = msg.sender;
            jackpot += 0.99 ether; 
            money_for_charity += 0.01 ether;
            return true;
        }
        return false;
    }
    
    function run_lottery(uint final_res) public 
        onlyByManager  
        onlyValidTicketNumber(final_res) {
        all_games[round_num].res = final_res;
        if(all_games[round_num].record[final_res].is_value == true) {
            address tmp = all_games[round_num].record[final_res].my_address;
            all_games[round_num].record[final_res].my_address.transfer(jackpot);
            emit CongratulationToWinner(tmp, "winner take all");
        }
    }


    // 更新最近受助者的接受资助的数额
    function add_or_update_amount(address new_people_in_need, uint amount) public {
        require(
            msg.sender == trusted_manager,
            "permission deny! this function can only invoked by the manager");    

        require(
            money_for_charity > amount,
            "not enough money");
        
        registered_people_in_need[new_people_in_need] = amount;    
    }
    
    function get_relief(uint amount) public onlyByRegisteredPeople {
        require(registered_people_in_need[msg.sender] > amount, 
        " no enough deposit!");
        registered_people_in_need[msg.sender] -= amount;
        money_for_charity -= amount;
        msg.sender.transfer(amount);
    }

    
}