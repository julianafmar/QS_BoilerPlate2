#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

//treetable_get concrete tests

void add_test1 (){
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, b_key = 0; 
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);

    assert(treetable_contains_key(tt, &a_key));

    assert(treetable_contains_key(tt, &b_key));

    treetable_destroy(tt);
}

void add_test2 (){
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 1, b_key = 0; 
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);

    assert(treetable_contains_key(tt, &a_key));

    assert(treetable_contains_key(tt, &b_key));

    treetable_destroy(tt);
}

void add_test3 (){
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = -1979711488, b_key = 0; 
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);
    treetable_add(tt, &b_key, b_val);

    assert(tt != NULL);

    assert(treetable_contains_key(tt, &a_key));

    assert(treetable_contains_key(tt, &b_key));

    treetable_destroy(tt);
}
