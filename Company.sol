pragma solidity ^0.6;
contract company{
    
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
