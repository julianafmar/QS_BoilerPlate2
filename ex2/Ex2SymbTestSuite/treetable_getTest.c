#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

#define SIZE 2

int main () {
    //treetable_get symbolic test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key, b_key;
    char a_val[SIZE], b_val[SIZE];
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&a_val, sizeof(char)*SIZE, "a_val");
    klee_make_symbolic(&b_val, sizeof(char)*SIZE, "b_val");

    treetable_add(tt, &a_key, a_val);

    /*
    Property: if treetable was created successfully it shouldn't be null
    */
    assert(tt != NULL);

    void *out;

    /*
    Property: If we call the function treetable_get and the key used as 
    argument is in the table, it should return CC_OK and it should set 
    the out parameter to the value of the node and it should return 
    CC_ERR_KEY_NOT_FOUND if the key is not in the table
    */
    assert(treetable_get(tt, &a_key, &out) == CC_OK && strcmp(out, a_val) == 0);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);

    return 0;
}