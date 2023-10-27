#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

#define SIZE 2

int main () {
    //treetable_get_first_key symbolic test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key;
    char a_val[SIZE];
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&a_val, sizeof(char)*SIZE, "a_val");

    void *out;

    /*
    Property: If a treetable is empty and we call the function 
    treetable_get_first_key, it should return CC_ERR_KEY_NOT_FOUND
    */
    assert(treetable_get_first_key(tt, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, a_val);

    /*
    Property: if treetable was created successfully it shouldn't be null
    */
    assert(tt != NULL);

    /*
    Property: If a treetable has nodes and we call the function 
    treetable_get_first_key it should return CC_OK and it should 
    set the out parameter to the lowest key in the table
    */
    assert(treetable_get_first_key(tt, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
    
    return 0;
}