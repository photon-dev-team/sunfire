/* Copied (and simplified) from hardware/ril/libril/ril.cpp */

typedef struct {
    int requestNumber;
    void * func1;
    int * func2;
} CommandInfo;

typedef struct {
    int requestNumber;
    int * func1;
    int wakeType;
} UnsolResponseInfo;

typedef struct RequestInfo {
    int32_t token;      //this is not RIL_Token
    CommandInfo *pCI;
    struct RequestInfo *p_next;
    char cancelled;
    char local;         // responses to local commands do not go back to command process
} RequestInfo;
