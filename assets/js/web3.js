if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));

    web3.eth.defaultAccount = web3.eth.accounts[1];

    var attendanceContract = web3.eth.contract(abi);

    var AttendanceManagement = attendanceContract.at('0x1CBa50D76BCB94442B7E8C79e352a36c3f7aec6a');
    console.log(AttendanceManagement);
}