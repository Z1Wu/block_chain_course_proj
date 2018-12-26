pragma solidity ^0.5.0;

contract Lottery {
    
    struct Game {
        uint round_num;
        uint res;
        uint state;
        mapping(uint => address) record;
    }

    uint public cur_round_num;

    // 确定中奖率
    uint difficulty;

    Game[] all_games;

    uint jackpot;

    uint ticket_price;

    // 用于慈善的钱数
    uint public money_for_charity;

    address payable trusted_manager;

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

    // uint represent the amount of money people can get
    mapping(address => uint) public registered_people_in_need;
    
    constructor() public {
        trusted_manager = msg.sender;
        money_for_charity = 0;
    }
    
    function new_game(string memory description) public onlyByManager {
        // 重新设置基本参数    
        cur_round_num = cur_round_num + 1;
        all_games.push(Game({
            round_num: cur_round_num,
            state: 0
        }));
    }
    
    // 只能在为当前回合下注
    function bet(uint prediction) public payable {
        // 投注，
        // @params: 
        require(msg.value == ticket_price);
        
        all_games[cur_round_num].record[prediction] = msg.sender;

         
    }
    
    // 开奖，把奖金发送给赢家
    function reveal(uint round_num, uint res) public onlyByManager{
        all_games[cur_round_num].res = res;
        // if no body then 
    }
    
    // 更新最近受助者的在受资助的数额
    function add_or_update_amount(address new_people_in_need, uint amount) public {
        require(
            msg.sender == trusted_manager,
            "permission deny! this function can only invoked by the manager");    
        require(
            money_for_charity > amount,
            "not enough money");
        registered_people_in_need[new_people_in_need] = amount;    
    }

    function get_charity() public {
        
    }

    // retrun 
    function check_deposit() public view returns (uint){
        return registered_people_in_need[msg.sender];
    }

    // the winner withdraw the money the won,
    function redeem_withdraw() public {
        


    }
        
}

// 
// contract Game {

//     address payable trusted_manager;

//     uint res;
    
//     uint state;
    
//     modifier onlyByManager() {
//         require(
//             msg.sender == trusted_manager,
//             "Sender not authorized."
//         );
//         _;
//     }

//     mapping(address => uint) record;

//     //
//     constructor(address pyaable ) {
//         address = 
//     }

//     function()

// }