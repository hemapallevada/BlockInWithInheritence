pragma solidity ^0.6;
import "https://github.com/hemapallevada/BlockIn/blob/master/projectPostJob.sol";
contract Employee is projectPost{
    
     address postAddress;
    projectPost postObject;
    constructor() public{
     instantiateContractProjectPost(msg.sender);}
struct profileEach{
string name;
address Personaddress;
uint CompanyId;
string role;
uint Salary;
string Company;
bool CompanyVerified;
string[][] educationQualifications;
}
mapping(address=>profileEach) profile;
function createProfile(string memory name,string memory role,uint salary,string memory Company) public{
    address personaddress=msg.sender;
    setName(name,personaddress);
    setRole(personaddress,role);
    setSalary(personaddress,salary);
    setCompany(personaddress,Company);
   // getCompanyIdByName(Company);
    setCompanyVerified(personaddress,false);
   
}
function instantiateContractProjectPost(address postobj) public{
postAddress=postobj;  
postObject=projectPost(postAddress);
    } 
function setName(string memory name,address add) private{
    profile[add].name=name;
}
function setCompanyVerified(address add, bool status) private{
    profile[add].CompanyVerified=status;
}
function setCanCompanyId(uint CompanyId,address add) private{
    profile[add].CompanyId=CompanyId;
}
function setRole(address add,string memory RoleName) private{
    profile[add].role=RoleName;
}
function setCompany(address add,string memory CompanyName) public{
    profile[add].Company=CompanyName;
}
function setSalary(address add,uint salary) private{
    profile[add].Salary=salary;
}

function getName(address add) public view returns(string memory){
    return profile[add].name;
}
function getCompanyId(address add) public view returns (uint CompanyId){
   return profile[add].CompanyId;
}
function getRole(address add,string memory RoleName) private{
    profile[add].role=RoleName;
}
function getCompany(address add,string memory CompanyName) public{
    profile[add].Company=CompanyName;
}
function getSalary(address add,uint salary) private{
    profile[add].Salary=salary;
}
function getCompanyVerified(address add)  public view returns(bool){
    return profile[add].CompanyVerified;
}
struct aboutPostsandLogin{
   uint lastlogin;
   uint totalposts;
   uint conCoins;
}
function onSignUp(address UserId) public{
    //callTransfer(minter,UserId,20);
    PostsandLogin[UserId].lastlogin=now;
    PostsandLogin[UserId].totalposts=0;
    PostsandLogin[UserId].conCoins=0;
}
function onDocumentUpload() public{
    //Yet to implement
}
mapping(address=>aboutPostsandLogin) PostsandLogin;
function onJobVerified(address CandidateId) public{
    setCompanyVerified(CandidateId,true);
}
function onLogin(address userId) public{
  uint  x=now;
  address minteradd=postObject.callMinter();
    if(x-PostsandLogin[userId].lastlogin>86400 && x-PostsandLogin[userId].lastlogin<=172800){
        if(PostsandLogin[userId].conCoins<35){
            
            postObject.callTransfer(minteradd,userId,PostsandLogin[userId].conCoins+5);
            PostsandLogin[userId].conCoins+=5;
        }
        else if(x-PostsandLogin[userId].lastlogin>86400){
            
             postObject.callTransfer(minteradd,userId,5);
             PostsandLogin[userId].conCoins=5;
        }
    }
    PostsandLogin[userId].lastlogin=x;
    
     
}

function onAnyPost(address userId) public{
    PostsandLogin[userId].totalposts+=1;
   
    require(PostsandLogin[userId].totalposts<20,"Sorry!, We cannot credit tokens Since you have uploaded 20 posts:)");
    //callTransfer(minter,userId,5);
}


function onSelection(address selectedCan,uint companyId,string memory Company,string memory rolename,uint salary) public {
setCanCompanyId(companyId,selectedCan);
setCompany(selectedCan,Company);
setRole(selectedCan,rolename);
setSalary(selectedCan,salary);

}


function createDummyProfiles(string memory name,address personaddress,uint CompanyId,string memory role,uint salary,string memory Company,bool verifiedStatus) public{
    setName(name,personaddress);
    setRole(personaddress,role);
    setSalary(personaddress,salary);
    setCompany(personaddress,Company);
   setCanCompanyId(CompanyId,personaddress);
    setCompanyVerified(personaddress,verifiedStatus);
    
}

function getProfile_Name(address candidateId) public view returns(string memory){
    return profile[candidateId].name;
}
function getProfile_Company(address candidateId) public view returns(string memory){
    return profile[candidateId].Company;
}

function getProfile_Salary(address candidateId) public view returns(uint){
    return profile[candidateId].Salary;
}
function referSomeone(uint postId,address CanId) public{
    postObject.addAReferer(msg.sender,CanId,postId);

}

}
