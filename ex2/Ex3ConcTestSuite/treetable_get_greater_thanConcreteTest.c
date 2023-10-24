#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

//treetable_greater_than concrete tests

void get_greater_test1 () {
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, b_key = 0;
    char a_val[] = "..", b_val[] = "..";

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);
    
    if (a_key < b_key) assert(treetable_get_greater_than(tt, &a_key, &out) == CC_OK && out == &b_key);
    else if (a_key > b_key) assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}

void get_greater_test2 () {
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 1, b_key = 0;
    char a_val[] = "..", b_val[] = "..";

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);
    
    if (a_key < b_key) assert(treetable_get_greater_than(tt, &a_key, &out) == CC_OK && out == &b_key);
    else if (a_key > b_key) assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}


void get_greater_test3 () {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = -1979711488, b_key = 0;
    char a_val[] = "..", b_val[] = "..";

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);
    
    if (a_key < b_key) assert(treetable_get_greater_than(tt, &a_key, &out) == CC_OK && out == &b_key);
    else if (a_key > b_key) assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}
