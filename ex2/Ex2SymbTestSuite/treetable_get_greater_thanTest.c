#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

#define SIZE 2

int main () {
    //treetable_greater_than symbolic test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key, b_key;
    char a_val[SIZE], b_val[SIZE];
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&a_val, sizeof(char)*SIZE, "a_val");
    klee_make_symbolic(&b_val, sizeof(char)*SIZE, "b_val");

    void *out;
    /*
    Property: If treetable has no nodes and we call the function 
    treetable_get_greater_than it should return CC_ERR_KEY_NOT_FOUND
    */
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);

    /*
    Property: if treetable was created successfully it shouldn't be null
    */
    assert(tt != NULL);

    /*
    Property: If treetable has nodes and we call the function 
    treetable_get_greater_than it should return CC_OK and it 
    should set the out parameter to the immediate successor of 
    the key given as argument
    */
    if (a_key < b_key) assert(treetable_get_greater_than(tt, &a_key, &out) == CC_OK && out == &b_key);
    else if (a_key > b_key) assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
    
    return 0;
}