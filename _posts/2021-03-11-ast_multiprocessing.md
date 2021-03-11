---
title: "Running ast Parsetrees as Separate Processes"
excerpt_separator: "<!--more-->"
categories:
  - Programming
tags:
  - python
  - parallelism
  - compilers
---

Python's [multiprocess.Process](https://docs.python.org/3/library/multiprocessing.html) makes [fork][1]ing and [spawn][2]ing intuitive - you don't have to worry about opening a new Python interpreter manually, etc. Here is a snippet that demonstrates the most interesting part of **Process**:

~~~python
p = mp.Process(target=fn, args=args, kwargs=kwargs)    
p.start()                                              
~~~

In short, the function **fn** will run in parallel, in a new process. You may pass positional parameters **args** or (named parameters)[3] **kwargs**, but these have to be (picklable)[4]. To generalize, the **Process** API allows us to pass functions to the new process, but what if we want to pass an AST Parsetree instead? Let's say we have the following scenario:

~~~python
codestring="import ..."
parsetree1=ast.parse(codestring)
parsetree2=mod_parsetree(parsetree1)

p = mp.Process(target=???, args=args, kwargs=kwargs)    
p.start()                                              
~~~

What would the target be?

Considering that:

~~~python
exec(parsetree2)
~~~

is what I ultimately want to happen inside the new process, my first approach was to pass [exec](https://docs.python.org/3/library/functions.html#exec) with parsetree2 as the first argument. However, this raized an error because apparently, parsetrees are not picklable (why not though?).

Since strings are picklable, I quickly found out that the [ast](https://docs.python.org/3/library/ast.html) module has an **unparse** function which will return the **str** equivalent of a given parsetree. Sadly, this function is only available since Python 3.9 but I was bound to Python 3.8. [astunparse](https://pypi.org/project/astunparse/) came to the rescue - it's a simple library (and beautifully written, check the [code](https://github.com/simonpercivall/astunparse) btw.) that gives us back the missing **unparse** functionality. Now we can do:

~~~bash
sudo python3 -m pip install astunparse
~~~

and

~~~python
codestring1="import ..."
parsetree1=ast.parse(codestring)
parsetree2=mod_parsetree(parsetree1)

codestring2=astunparse.unparse(parsetree2)
p = mp.Process(target=exec, args=(codestring2))    
p.start()                                              
~~~

And the day is saved! I am not happy that I had to include another dependency, which may or may not work for all possible input cases (e.g. complex programs). I wonder if this could be done in a simpler way:

## Warning this is just speculative, not tested

Since **multiprocess.Process** allows us to pass a function to the other process, we could prepare a special function using [functools](https://docs.python.org/3/library/functools.html) to execute there. This would look something among the lines of:

~~~
def exectree(tree):
    exec(tree):
foreign_function = partial(exectree,parsetree2)
p = mp.Process(target=exec)    
p.start()                                              
~~~

Notice that we don't have to pass any parameters to the other process this time, because they are embedded in the function we are passing.


[4]: https://docs.python.org/3/library/pickle.html

[3]: https://en.wikipedia.org/wiki/Named_parameter

[1]: https://en.wikipedia.org/wiki/Fork_(system_call)
[2]: https://en.wikipedia.org/wiki/Spawn_(computing)
