if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));

    web3.eth.defaultAccount = web3.eth.accounts[0];

    var attendanceContract = web3.eth.contract(abi);

    var acctFromAddress="0x00f4e7EAcD5127473183e52eFe1776d1d19a6895";

    var AttendanceManagement = attendanceContract.at('0x72E3B6EdFf7bEE99404c0fbcb863144c6fc81Faf');
    console.log(AttendanceManagement);
}