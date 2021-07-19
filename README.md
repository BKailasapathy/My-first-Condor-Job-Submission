# My-first-Condor-Job-Submission

  - [Introduction to submit jobs in condor](https://github.com/BKailasapathy/My-first-Condor-Job-Submission/blob/main/README.md#introduction-to-submit-jobs-in-condor)
  - [My Exercise](https://github.com/BKailasapathy/My-first-Condor-Job-Submission#here-is-my-exercis)

## Introduction to submit jobs in condor


*This document was created by Marcello about condor job submission*

Condor is a submission system, and as all such systems, it will execute a file (a script) in a different machine and so you need to provide something that is auto-consistent, able to gather whatever is needed in input and send back whatever is needed in output.

So, in order to make sure your executable works you can emulate the behaviour of the submission system. To do so, 
- Build the script
- Copy the script in a empty directory 
- Execute it
- If there are no errors or missing inputs, check if the outputs are where you expected them to be.

Do NOT assume you can cd in the directory where you have all your needed files... If this is possible it is still, most of the time, a bad idea, since you will have concurrent running code on the same filesystem area and this can be a bottleneck. So you need to evaluate pros and contros...

In many submission systems you can indicate what you need in input and what you need in output, so that the script does not need to copy whatever is needed at all… but we can forget for now this option.

Let's do something simple to understand Condor at this point… 

Let's take a simple script test.csh

```bash

#!/bin/tcsh
 
echo Working Directory 
pwd
 
echo Host
hostname
 
echo $1 and $2 
 
exit 0
```

```chmod a+x test.csh```
(the last command is to make it explicitly executable)

The script does not depends on input file and will not produce output file, but it requires two parameters so to execute it, you type
```./test.csh Ciao Bala```

It will print in the standard output
**Ciao Bala**.

Let’s see now, how can we instruct Condor to execute it on batch. To do so, you need to produce a file, let’s call it *testcondor.cond*  (arbitrary filename and arbitrary filetype), where this is done.

```
executable = test.csh
output = test.out
error  = test.err
log    = test.log
Queue arguments from (
  00100_12113 run_01
  00100_12113 run_02
  00100_12113 run_03
  00100_12113 run_04
  00100_12113 run_05
  00100_12113 run_06
  00100_12113 run_07
  00100_12113 run_08
  00100_12113 run_09
  00100_12113 run_10
  00100_12123 run_01
  00100_12123 run_02
  00100_12123 run_03
  00100_12123 run_04
  00100_12123 run_05
  00100_12123 run_06
  00100_12123 run_07
  00100_12123 run_08
  00100_12123 run_09
) 
```
As you see in the above code, we have few tags
- **executable** - Here you indicate the filename of the executable (script)
- **output** - This is used to put in a file whatever the executable write in “standard output” (i.e. the screen, cout in c++)
- **error** - This is used to put in a file whatever the executable write in “standard error” (i.e. the screen, cerr in c++)
- **log** - This is used to put in a file the submission system messaging for instance if it fails it tells you, cryptically, why..
- **Queue** - Is the tag that makes the actual steering of the submission. Can have very different syntax… here it will submit 19 jobs one for each pair of arguments

I guess you can try this out now to see if so far you are good. To do that, the command in recas is created.

```condor_submit -name ettore testcondor.cond```

You can open *test.log* to see what is going on, and a file *test.out* will start being written. As you can see all jobs will write in a unique output file, that is not very convenient. So we will pass to the next level: *testcondor2.cond*

```
executable = test.csh
output = test$(Process).out
error  = test$(Process).err
log    = test$(Process).log
bala = Ciao
arguments = $(bala) $(Item)
Queue 1 in ( 100, 200, 300, 400, ALL)
```

In this Condor file we see how to have different output, error, and log files. We use the internal variable *$Process* which will go from 0 to the number-1 of jobs submitted (here 4)
I also define a variable *bala* and use the arguments tag where *bala* is used together with the internal variable *$(Item)* which will pick up the values in the Queue tag. Queue will submit 1 job per item. 

```
condor_submit -name ettore testcondor2.cond
```

Here is my exercise
-------------------
This execrise is  executed from recas.

- CMSSW [python script](https://raw.githubusercontent.com/BKailasapathy/My-first-Condor-Job-Submission/main/FastJetSimple1.py) 
- CMSSW [.cc file](https://raw.githubusercontent.com/BKailasapathy/My-first-Condor-Job-Submission/main/FastJetSimple1.cc)
- condor job submission [file](https://raw.githubusercontent.com/BKailasapathy/My-first-Condor-Job-Submission/main/testCondor2.cond) : (just outside the CMSSW#_#_# directory)
- [Bash script](https://raw.githubusercontent.com/BKailasapathy/My-first-Condor-Job-Submission/main/cmsRun.sh)



