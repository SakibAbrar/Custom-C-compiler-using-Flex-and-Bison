#include <iostream>
#include <fstream>
#include <list>
#include <cstdio>

std::ofstream logFile("log.txt");


/*
////////////////////////////////////////
1.We will be avoiding any global variable uses 
because later that will create problems while
using flex and bison together.


2.Try to avoid using namespace std.
Because in future you're going to use this cpp file
as a header file with extention .h.
And it is best practice not to use "using namespace std" in
the header files.

3.In stead of opening file and redirecting output stream to
them, use streams to write in files.
////////////////////////////////////////
*/

///this class will contain every symbol individually. 
class SymbolInfo{

private:
    std::string name;
    std::string type;
    std::string declarationType = "void";

public:
    
    bool isArray = 0;
    bool isFunction = 0;
    SymbolInfo *next;


    SymbolInfo(){
        next = nullptr;
    }

    SymbolInfo(std::string _Name, std::string _Type){
        name = _Name;
        type = _Type;
        next = nullptr;
    }


    void setName(std::string _name){
        name = _name;
    }


    void setType(std::string _type){
        type = _type;
    }

    void setDeclarationType (std::string _declarationType){
        declarationType = _declarationType;
    }


    std::string getName(){
        return name;
    }


    std::string getType(){
        return type;
    }

    std::string getDeclarationType(){
        return declarationType ;
    }

    void makeArray(){
        isArray = 1;
        isFunction = 0;
    }

    void makeFunction(){
        isFunction = 1;
        isArray = 0;
    }

};


///Everytime we get a new scope we will create a new scopetable
///and store variables within that scope in that.
class ScopeTable{
    SymbolInfo **bucket;
    int *size;
    
public:
    static int count;
    static int bucketSize;
    int id;
    ScopeTable *parentScope;

    ScopeTable(){
        bucket = new SymbolInfo*[bucketSize];
        size = new int[bucketSize];

        for(int idx = 0; idx<bucketSize; idx++){
            bucket[idx] = nullptr;
            size[idx] = 0; 
        }
        id = ++count;
        parentScope = nullptr;
        logFile << "New ScopeTable with id " << this->id << " created" << std::endl << std::endl;
    }

    ScopeTable(ScopeTable* parent){

        bucket = new SymbolInfo*[bucketSize];
        for(int idx = 0; idx<bucketSize; idx++){
            bucket[idx] = nullptr;
        }
        parentScope = parent;
        id = ++count;
        logFile << "New ScopeTable with id " << this->id << " created" << std::endl << std::endl;
    }


    ///I made a bigmod like power function so that it can be used in the hashtable like thing in this class
    int power( int a, int p, int m ){
        if(p == 0) return 1;

        if(p & 1)
            return ((a % m)*(power(a, p-1, m ))) % m;

        else{
            int tmp = power (a, p/2, m );
            return (tmp * tmp) % m;
        }
    }

    ///this is a simple hash function which uses mod 19
    int hash(std::string s){
        int ch;
        int val = 0;
        for(int i = 0; i<s.size(); i++){
            ch =  s[i-1] - 'a' + 1;
            val += ch*power(19, i, bucketSize);
            val %= bucketSize;
            if(val<0) val+=bucketSize;
        }
        return val;
    }


    ///this looks up in the scope table and returns a SymbolInfo pointer
    SymbolInfo* lookUp(std::string s){
        int hval;

        hval = hash(s);
        int pos = 0;
        for(SymbolInfo* idx = bucket[hval]; idx!=nullptr; idx = idx->next){

            if((*idx).getName() == s){
                logFile << "Found in ScopeTable# " << this->id <<  "at position " << hval << ", " <<  pos << std::endl << std::endl;
                return idx;
            }
            pos++;

        }

        logFile << "Not found" << std::endl << std::endl;

        return nullptr;
    }


    ///Inserts a SymbolInfo in the ScopeTable 
    bool insert(std::string name, std::string type){

        SymbolInfo* temp = lookUp(name);

        //std::cout << "all fine" << std::endl;


        /// we won't be allowing any duplicate(by name) in each ScopeTables
        if(temp){
            logFile << " < " << name << " : " << type << " > " << " already exists in current ScopeTable" << std::endl << std::endl;
            return false;
        }

        int idx = hash(name);
        temp = bucket[idx];

        int pos = 0;

        //std::cout << "all fine" << std::endl;

        if(!temp){
            bucket[idx] = new SymbolInfo(name, type);
            //std::cout << "all fine" << std::endl;
        }

        else{
            SymbolInfo* prev = nullptr;

            while(temp){
                prev = temp;
                temp = temp->next;
                pos++;
            }
            temp = new SymbolInfo(name, type);
            prev->next = temp;
        }
        logFile << "Inserted in ScopeTable# " << this->id << " at position " << idx << ", " << pos << std::endl << std::endl;
        return true;
    }


    ///it will search the corresponding name and delete that symbol
    bool deleteSymbol(std::string  element){
        int hval;

        hval = hash(element);

        
        ///if in the begining of the hash table of any indices
        if(bucket[hval]-> getName() == element){
            SymbolInfo * temp = bucket[hval];
            bucket[hval] = bucket[hval] -> next;
            delete temp;
            logFile << "Found in ScopeTable# " << this->id << "at position " << hval << ", " << 0 << std::endl;

            logFile << "   Deleted entry at " << hval << ", " << 0 << " from current ScopeTable" << std::endl << std::endl;

            return true;
        }

        SymbolInfo* prev = nullptr;
        int pos = 0;

        ///if not then dig deeper
        for(SymbolInfo* idx = bucket[hval]; idx!=nullptr; idx = idx->next){

            if((*idx).getName() == element){
                prev-> next = idx->next;
                delete idx;
                logFile << "Found in ScopeTable# " << this->id << "at position " << hval << ", " << pos << std::endl;
                logFile << "   Deleted entry at " << hval << ", " << pos << " from current ScopeTable" << std::endl << std::endl;
                pos++;
                return true;
            }
            prev = idx;

        }
        logFile << element <<" not found" << std::endl;
        return false;
    }

    void print(){
        logFile<< " ScopeTable # " << this->id << std::endl;
        for(int idx = 0; idx < bucketSize; idx++){
            SymbolInfo * temp;
            temp = bucket[idx];
            logFile << " " << idx << " --> ";
            while(temp){
                logFile << " < " << temp->getName() << " : " << temp->getType() << " > " ;
                temp = temp -> next;
            }
            logFile << std::endl;
        }
        logFile << std::endl;
    }

    ///Must needed!!
    ///else you may keep getting null pointer exceptions
    ///and segmentation fault:core dumped later.
    ~ScopeTable(){
        for(int idx = 0; idx < this->bucketSize; idx++){
            delete bucket[idx];
        }
        delete[] bucket;
    }

};



///SymbolTable class keeps a list of ScopeTables and handles all of them. 
class SymbolTable{
    std::list<ScopeTable*> head;
    int length;

public:
    ScopeTable * currentScope;

    SymbolTable(){
        currentScope = nullptr;
        length = 0;
    }

    void enterScope(){
        ScopeTable *newScope;
        newScope = new ScopeTable(currentScope);
        head.push_back(newScope);
        currentScope = newScope;
        length++;
    }

    bool deleteItem(std::string data){
        return currentScope->deleteSymbol(data);
    }


    SymbolInfo* lookUp(std::string data){
        SymbolInfo* ret = currentScope->lookUp(data);

        if(ret){
            return ret;
        }
        
        if(currentScope->parentScope)
            return currentScope->parentScope->lookUp(data);
        
        return nullptr;
    }

    void exitScope(){
        ScopeTable * temp = currentScope->parentScope;
        head.pop_back();
        length--;
        logFile << "ScopeTable with id " << currentScope->id  << " removed" << std::endl << std::endl;
        delete currentScope;
        currentScope = temp;
    }

    bool insert(std::string name, std::string type){
        return currentScope->insert(name, type);
    }

    bool remove(std::string tokenName){
        return currentScope->deleteSymbol(tokenName);
    }

    void printCurrentScope(){
        if(!currentScope)
            currentScope->print();
        logFile << "The current scope is null\n";
        
    }

    void printAllScope(){
        std::list <ScopeTable*> :: iterator it; 
        for(it = head.begin(); it != head.end(); ++it){
            (*it)->print();
        }
        logFile << '\n';
    }

};

int ScopeTable::count = 0;
int ScopeTable::bucketSize = 7;



int main(){

    SymbolTable sTable;

    sTable.enterScope();

    char inp;
    char printType;
    
    std::string name, type;

    std::cout << "('I' to insert,'L' to look up,'P' to print,'D' to remove" << std::endl;
    std::cout << "'S' to enter new Scope,'E' to exit Scope)" << std:: endl;
    std::cout << "(type)>>";

    while(std::cin >> inp){
        
        switch(inp){
        case 'I':
            std::cin >> name >> type;
            sTable.insert(name, type);
            break;

        case 'L':
            std::cin >> name;
            type = "whatever";
            sTable.lookUp(name);
            break;
        
        case 'P':
            std::cin >> printType;
            if(printType == 'C')
                sTable.printCurrentScope();
            else if(printType == 'A'){
                sTable.printAllScope();
            }
            
            break;
        
        case 'D':
            std::cin >> name;
            sTable.remove(name);
            break;
        
        case 'S':
            sTable.enterScope();
            break;

        case 'E':
            sTable.exitScope();
            break;

        default:
            break;
        }
        std::cout << "('I' to insert,'L' to look up,'P' to print,'D' to remove" << std::endl;
        std::cout << "'S' to enter new Scope,'E' to exit Scope)" << std:: endl;
        std::cout << "(type)>>";
    }

    logFile.close();
    return 0;

}