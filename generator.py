import sys,time,random,string
numrows = string.atoi(sys.argv[1])

opponent = [
   'FC Booyah',
   'Real Real',
   'Boondocks United',
   'Sticks FC',
   'Gorilla Futbal'
   'Nine Random Guys'
]

weather = [
    "Clear",
    "Hot",
    "Snowing",
    "Hot and humid",
    "Hailing",
    "Lightning and blustery",
    "Tornado",
    "Severe flooding",
    "Cats and dogs living together",
]

gametype = [
   'Friendly',
   'Tournament',
   'League',
   'Grudge match'
]

field = [
   'Grass -- good condition',
   'Grass -- poor condition',
   'Grass -- ATVs are scared',
   'Turf -- good condition',
   'Turf -- poor condition',
   'I thought they said turf!!??',
   'We couldn\' find the field',
   'Field exists only in someone\'s troubled mind',
   'Dirt',
   'Mud',
]

rdm_s = lambda data:  data[random.randint(0,len(data)-1)]
rdm_n = lambda floor,ceiling:  random.randint(floor,ceiling)

def date_gen():
   # return a random date between now the next three years
   res = time.localtime(time.time() + (random.randint(1,365*3)*86400))
   lookup = ['OneBasedIdx','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
   return '%d-%s-%d' % (res[2],lookup[res[1]],res[0])

while numrows != 0:
    numrows = numrows - 1
    print "%s,%s,%s,%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d" % (rdm_s(opponent),date_gen(),rdm_s(weather), \
       rdm_s(gametype),rdm_s(field),rdm_n(0,5),rdm_n(0,5),rdm_n(0,5),rdm_n(0,5), \
       rdm_n(0,20),rdm_n(0,20),rdm_n(0,20),rdm_n(0,20), \
       rdm_n(0,6),rdm_n(0,6),rdm_n(0,6),rdm_n(0,6), \
       rdm_n(0,20),rdm_n(0,20),rdm_n(0,20),rdm_n(0,20))

