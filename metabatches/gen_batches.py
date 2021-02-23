#!/usr/bin/env python3

import os
import random
import secrets
import shutil

# Metabatch is a template of a batch for a particular evaluation method
# DSIS (variant 2) and DSCQS are implemented as examples
# metabatch_name = 'DSIS2'
metabatch_name = 'DSCQS'

# Content tag index specifies where to look for the content name in the filename.
# e.g. here crop_08_00011_TE_1744x1160_8bits_sRGB_100.png "00011" is the name of
# the original content and it has index 2 when the file name is splitted by "_"
# This is used to prevent the same content to apprear in two consequent steps.
content_tag_idx = 2

# I case we have to many stimuli for one session we can split the evaluation in
# multiple session. num_of_parts is the number of sessions.
num_of_parts = 1

# Read the full stimuli list from file
with open(metabatch_name+'/stimuli_list.txt', 'r') as f:
    stimuli_list = f.read().splitlines()


subject_ids = [f'perm{x:04d}' for x in range(15)]
# subject_ids = ['perm0001']
#
# with open('subject_ids.csv', 'r') as f:
#     subject_ids = f.read().splitlines()

def get_permutation(input_list):
    'This function randomizes the order of stimuli'
    count2 = 0 # safety counter, prevents infitite loop
    while count2 < 20:
        s_list = [(s.split('_')[content_tag_idx],s) for s in input_list]
        s_rand = []
        x = random.choice(s_list)
        s_rand.append(x[1])
        s_list.remove(x)
        count = 0 # safety counter, prevents infitite loop
        while s_list:
            # pick a random element from the full stimuli list
            x = random.choice(s_list)
            count += 1
            # check if the picked content is the same as previous
            if not x[0] in s_rand[-1]:
                s_rand.append(x[1])
                s_list.remove(x)
                count = 0
            if count >= 20:
                count2 += 1
                s_rand = []
                break
        if not s_list:
            break
    return(s_rand)

num_of_st = int( (len(stimuli_list)/float(num_of_parts)) )
# print(f'Parts: {num_of_parts}, stimuli per part: {num_of_st}')
if num_of_st*num_of_parts < len(stimuli_list):
    # print(f'{num_of_st}*{num_of_parts}={num_of_st*num_of_parts}')
    num_of_st += 1
    # print(f'Parts: {num_of_parts}, stimuli per part: {num_of_st}')
if len(stimuli_list)%num_of_st == 0:
    num_of_parts = int(len(stimuli_list)/num_of_st)
# acc = 0
# for x in range(num_of_parts):
#     acc+=num_of_st
#     d = len(stimuli_list)-acc
#     if d > 0:
#         d = 0
#     print(f'{x+1:02d}: {(num_of_st+d):02d} {acc+d:02d}')
print(f'Parts: {num_of_parts}, stimuli per part: {num_of_st}')

batches_list=[]


# Swap the sides for randomly picked half images.
def swap_rand_half(work_list):
    def pick_rand_half_idx():
        indexes = list(range(len(work_list)))
        for i in range(int(len(work_list)/2)):
            elem = random.choice(indexes)
            indexes.remove(elem)
            yield elem
    for i in pick_rand_half_idx():
        pair = list(reversed(work_list[i].split(' ')))
        work_list[i] = ' '.join(pair)

# Iterate over batches
for n in subject_ids:
    s_list = stimuli_list
    for p in range(1,num_of_parts+1):
        stimuli_list_p = s_list[:num_of_st]
        s_list = s_list[num_of_st:]
        print(num_of_st,len(stimuli_list_p),len(stimuli_list_p))
        # with open('stimuli_perm_p'+str(p)+'n0'+'.txt', 'w') as f:
        #     for i,line in enumerate(stimuli_list_p):
        #         f.write(str(i+1)+','+line+'\n')
        batch_id=str(n)+'p'+str(p)
        dir='batches/'+batch_id+'/'
        try:
            os.makedirs(dir,exist_ok=True)
        except OSError:
            print ("Creation of the directory %s failed" % dir)

        with open(metabatch_name+'/definition.qcs.tpl', 'r') as f:
            def_qcs = f.read()

        stimuli_perm = get_permutation(stimuli_list_p)
        swap_rand_half(stimuli_perm)
        with open('batches/stimuli_perm_'+batch_id+'.csv', 'w') as f:
            for i,line in enumerate(stimuli_perm):
                f.write(str(i+1)+','+line+'\n')
        with open(dir+'definition.qcs', 'w') as f:
                f.write(def_qcs.format(
                    batch_id=batch_id,
                    conf_token=secrets.token_hex(16),
                    stimuli_list='\n'.join(stimuli_perm)
                ))
        shutil.copy(metabatch_name+'/page.instructions.html',dir)
        batches_list.append(batch_id)

with open('batches/batches_list.csv', 'w') as f:
    for i,line in enumerate(batches_list):
        f.write(str(i+1)+','+line+'\n')



# s_list = [(s.split('_')[3],s) for s in stimuli_list]
# s_list.sort()
# with open('stimuli.txt', 'w') as f:
#             for i,line in enumerate([s[1] for s in s_list]):
#                 f.write(line+'\n')
