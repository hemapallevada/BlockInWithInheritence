pragma solidity ^0.6;
pragma solidity ^0.6;
pragma solidity ^0.6;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract MyToken is  ERC20 {
    address public minter;
    constructor()ERC20("Mytoken","$") public{
       _mint(msg.sender,21000000);
       minter=msg.sender;
     
    }
  function getMinter() public view returns(address){
  return minter;
  }
    
     
}

/********************************
 * *******************************/
contract company is MyToken{
    
    constructor()public{
      
    }
struct Company{
   
    address CompanyId;
    string CompanyName;
    }

mapping(address=> Company) AllCompanies;
mapping(address=> uint) AvailableCompanies;
mapping(string=> Company) NameToAddress;

function onCompanySignUp(string memory CompanyName ) public{
    
    require(isCompany(msg.sender)!=true,"Company With Same Address Already Exists");
    require(CompanyWithName(CompanyName)!=true,"Company with this name already Exists");
    Company memory cur_company;
   
    cur_company.CompanyName=CompanyName;
    cur_company.CompanyId=msg.sender;
    AllCompanies[msg.sender]=cur_company;
    NameToAddress[CompanyName]=cur_company;
    AvailableCompanies[msg.sender]=1;
    
}

function isCompany(address add) public view returns(bool){
    if(AvailableCompanies[add]==0){
        return false;
    }return true;
}
function CompanyWithName(string memory name) public view returns(bool){
    if(isCompany(NameToAddress[name].CompanyId))
        return true;
    return false;
}
function getAddressByName(string memory name) public view returns(address ){
    require(CompanyWithName(name),"No company with this name");
   return NameToAddress[name].CompanyId;
}
function getCompany(address id) public view returns(string memory){

return AllCompanies[id].CompanyName;
}


}

/********************************
 * *******************************/
 
 
contract Employee is company{
    
     
    constructor() public{
     }
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
  
    if(x-PostsandLogin[userId].lastlogin>86400 && x-PostsandLogin[userId].lastlogin<=172800){
        if(PostsandLogin[userId].conCoins<35){
            
            transferFrom(minter,userId,PostsandLogin[userId].conCoins+5);
            PostsandLogin[userId].conCoins+=5;
        }
        else if(x-PostsandLogin[userId].lastlogin>86400){
            transferFrom(minter,userId,5);
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

}




/********************************
 * *******************************/




contract projectPost is Employee{
    
    
    uint no_of_posts;
     
     address owner;
   
    struct post{
        uint postId;
        uint no_of_available_posts;
        string roleName;
        uint Salary;
        string companyName;
        string qualificationRequired;
	mapping(address => address[]) referers;
        bool Status;
    } post cur_post;
    
mapping(uint => post) postAll;
   
    
  constructor() public{
   
   no_of_posts=0;
   
  }

    function callTransfer(address send,address received,uint am) payable public{
      approve(send,am+100);
        transferFrom(send,received,am);
    }
    function callMinter() public view returns(address){
       return getMinter();
    }
    
function postJob(string memory RoleName,uint salary,string memory qualificationRequired,uint number_of_available_posts) public{
        owner=msg.sender;
        require(isCompany(owner),"You are not registered as company");
        string memory Company=getCompany(msg.sender);
        uint cur_posts_no=no_of_posts+1;
        setPostId(cur_posts_no);
        setPostName(RoleName);
        setCompany(Company);
        setSalary(salary);
        setAvailablePosts(number_of_available_posts);
        setRequiredQualification(qualificationRequired);
       setStatus(false);
        uint totalAmount=balanceOf(owner);
        require(totalAmount>=(number_of_available_posts*1000),"No enough balance to post a project");
postAll[cur_post.postId]=cur_post;
approve(owner,number_of_available_posts*1000);
callTransfer(msg.sender,minter,number_of_available_posts*1000);
no_of_posts+=1;
    } 
    function setPostId(uint postId) private{
        cur_post.postId=postId;
    }
  
  function setPostName(string memory name) private{
        cur_post.roleName=name;
    }
    function setStatus(bool status) private{
        cur_post.Status=status;
    }
    function setSalary(uint salary) private{
        cur_post.Salary=salary;
    }
    function setAvailablePosts(uint AvailablePosts) private{
        cur_post.no_of_available_posts=AvailablePosts;
    }
     function setCompany(string memory company) private{
         cur_post.companyName=company;
     }
     function setRequiredQualification (string memory qualification) private{
         cur_post.qualificationRequired=qualification;
     }
     function addAReferer(address referer,address referee,uint id) public {
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
         require(getCompanyId(referee)== id,"You should be an Employee of that company");
         postAll[id].referers[referer].push(referee);
     }
  function current_postId() public view returns(uint)  {
      return  cur_post.postId;
    }
  function  getRoleName() public view returns(string memory){
       return cur_post.roleName;
    }
    function getNoOfAvailablePosts() public view returns(uint){
    return   cur_post.no_of_available_posts;
    }
  function getotalPosts() public view returns(uint){
      return no_of_posts;
  }
  function getStatus() public view returns(bool){
      return cur_post.Status;
  }
   function  getRoleNameById(uint id) public view returns(string memory){
       require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
       return postAll[id].roleName;
    }
     function getNoOfAvailablePostsById(uint id) public view returns(uint){
         require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
    return postAll[id].no_of_available_posts;
    }
    function getStatusById(uint id) public view returns(bool){
        require(postAll[id].no_of_available_posts!=0,"Post either doesn't exists or filled");
      return postAll[id].Status;
  }
  
function getReferredPerson(uint postId,address selectedCan) public view returns (address[] memory){
    return postAll[postId].referers[selectedCan];
}
    function getSalary(uint postId) public view returns (uint){
        return postAll[postId].Salary;
        
    }
    function getCompany(uint postId) public view returns(string memory){
        return postAll[postId].companyName;
    } 
    
    function createDummyPosts(uint postId,string memory roleName,uint Salary,string memory companyName,string memory qualificationRequired,bool Status,uint no_of_available_posts)public{
    postAll[postId].postId=postId;
    postAll[postId].roleName=roleName;
    postAll[postId].Salary=Salary;
    postAll[postId].companyName=companyName;
    postAll[postId].qualificationRequired=qualificationRequired;
    postAll[postId].Status=Status;
    postAll[postId].no_of_available_posts=no_of_available_posts;
   /* uint postId;
        uint no_of_available_posts;
        string roleName;
        uint Salary;
        string companyName;
        string qualificationRequired;
	mapping(address => address[]) referers;
        bool Status;*/
    
}
function onCandidateSelect(address CandidateId,uint postId) public{
    uint totalReferers=getReferredPerson(postId,CandidateId).length;
    uint insAmount=1000/totalReferers;
    for(uint i=0;i<totalReferers;i++){
        callTransfer(minter,msg.sender,insAmount);
    }
}

}
