// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.18;

contract Owned {
    address owner;
    string password;
    
    
    
    function Owned() public {
        owner = msg.sender;
        password = "";
    }
    
   modifier onlyOwner {
       require(msg.sender == owner);
       _;
   }
}

contract AttendanceSheet is Owned {
    
    struct Student {
        uint id;
        uint dob;
        string fName;
        string course;
        string dept;
        uint year;
        string degree;
        uint attendanceValue;
        uint[] tracking;
    }
    
    struct Teacher {
        uint tid;
        string name;
        string course;
        string department;
        string password;
    }

    
    mapping (uint => Student) public studentList;
    uint[] public studIdList;
    
    mapping (uint => Teacher) public teacherList;
    uint[] public teacherIdList;
    string[] public teacherCourseList;


    
    
    event studentCreationEvent(
        
        uint dob,
        string fName,
        string dept,
        string degree,
        uint year
    );
    
    event teacherCreationEvent(
       string name,
       string course,
       string department,
       string password
    );
   
   
  // Login for Admin
    function adminLogin(address _id,string memory _password) onlyOwner public view returns(bool){
        if((Owned.owner==_id) &&(keccak256(bytes(Owned.password))==keccak256(bytes(_password)))){
            return true;
        }
        else{
            return false;
        }
    }
   
   // Creating Student
    function createStudent(uint _id, uint _dob, string _fName, string _dept, string _degree, uint _year) onlyOwner public returns(bool,string){
            //var student = studentList[_studId];
            var student = studentList[_id];
            //require(student.id != _id);
            if(student.id != _id){
                student.id = _id;
                student.dob = _dob;
                student.fName = _fName;
                student.dept = _dept;
                student.degree = _degree;
                student.year = _year;
                student.attendanceValue = 0;
                studIdList.push(_id) -1;
                studentCreationEvent( _dob, _fName, _dept, _degree, _year);
                return(true,"Student added successfully");
            }else{
                return (false,"already exists");
            }
    }
    
    
     // Student login
    function loginStudent(uint _id, uint _dob) public view returns(bool,string){
        
            if(studentList[_id].id==_id){
                if(studentList[_id].dob==_dob){
                    return(true,"login successfully");
                }else{
                    return(false,"incorrect password");
                }
            }else{
                return(false,"id does not exists");
            }
        }
    
    
    //Creating Teacher
    function createTeacher(uint _tid, string _name, string _course, string _department, string _password) onlyOwner public returns(bool,string){
        var teacher = teacherList[_tid];
        
        if(teacher.tid != _tid){
            teacher.tid = _tid;
            teacher.name = _name;
            teacher.course = _course;
            teacher.department = _department;
            teacher.password = _password;
            teacherIdList.push(_tid) -1;
            teacherCourseList.push(_course);
            teacherCreationEvent(_name, _course, _department, _password);
            return(true,"signup");
        }else{
                return(false,"already exists");
        }
    }
    
    
     
    //Professor login
    function loginTeacher(uint _tid, string _password) public view returns(bool,string){
        if(teacherList[_tid].tid==_tid){
            if(keccak256(bytes(teacherList[_tid].password))==keccak256(bytes(_password))){
                return(true,"login successfully");
            }else{
                return(false,"incorrect password");
            }
        }else{
            return(false,"id does not exists");
        }
    }
    
  
  // Student Enrolling course 
  function enrollCourse(uint _id, string _cname) public{
      for(uint i=0;i<teacherIdList.length;i++){
          uint j = teacherIdList[i];
          if((studentList[_id].id == _id) && (keccak256(bytes(teacherList[j].course)) == (keccak256(bytes(_cname))))){
              studentList[_id].course=_cname;
              
            }
      }
  }
   
     // teacher course
     function tecourse(string _course) public view returns(uint,string){
         for(uint i=0;i<teacherIdList.length;i++){
             uint j = teacherIdList[i];
             if((keccak256(bytes(_course))) == keccak256(bytes(teacherList[j].course))){
                 return(teacherList[j].tid,teacherList[j].name);
             }
         }
     }

   // View course of a particular student
   function seeCourse(uint _id) public view returns(string){
       return studentList[_id].course;
   }
   
     

    
    function addAttendance(uint _studId) public onlyOwner {
        studentList[_studId].attendanceValue = studentList[_studId].attendanceValue+1;
        studentList[_studId].tracking.push(block.timestamp);
        //time.push(block.timestamp);
    }
    
    // Increment attendanceValue for a particular student and getting time
    function incrementAttendance(uint _studId) view  onlyOwner public returns(uint256[]){
       
        return studentList[_studId].tracking;
    }
    
    
    // uint256[] public time;
    
    // function addAttendance(uint _studId) public onlyOwner {
    //     studentList[_studId].attendanceValue = studentList[_studId].attendanceValue+1;
    //     time.push(block.timestamp);
    // }
    
    // // Increment attendanceValue for a particular student and getting time
    // function incrementAttendance() view  onlyOwner public returns(uint256[]){
       
    //     return time;
    // }
    
    // // Decrement attendanceValue for a particular student
    // function decrementAttendance(uint _studId) onlyOwner public returns(uint256){
    //     if(studentList[_studId].attendanceValue >= 1){
    //         studentList[_studId].attendanceValue = studentList[_studId].attendanceValue-1;
    //         time = block.timestamp;
    //         return time;
            
    //     }else{
    //         studentList[_studId].attendanceValue = 0;
    //     }
    // }
    
    // Get all students IDs
    function getStudents() view public returns(uint[]) {
        return studIdList;
    }
    
    // Get all teachers IDs
    function getTeachers() view public returns(uint[]) {
        return (teacherIdList);
    }
    
    // Get particular student info
    function getParticularStudent(uint _studId) public view returns (uint,string, uint, string, string, uint, uint) {
        return (studentList[_studId].id,studentList[_studId].fName, studentList[_studId].attendanceValue, studentList[_studId].dept, studentList[_studId].degree, studentList[_studId].year, studentList[_studId].dob);
    }
    
    // Get particular teacher info
    function getParticularTeacher(uint _tid) public view returns (uint , string , string , string , string ) {
        return (teacherList[_tid].tid,teacherList[_tid].name, teacherList[_tid].course, teacherList[_tid].department, teacherList[_tid].password);
    }
   
    
    
    // count no of Students
    function countStudents() view public returns (uint) {
        return studIdList.length;
    }
    
    // count no on teachers
    function countTeachers() view public returns (uint) {
        return teacherIdList.length;
    }
    
}
