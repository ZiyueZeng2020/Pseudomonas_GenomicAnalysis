#!/usr/bin/env python
 
####For creating a presence absence table of effectors from the gutmann effector list using blast outfmt 6
####Give path to effector dirs containing a blast result table
#The table will be generated in the place where this scirpt is pythoned. However, we can define output_file_path = "/mnt/shared/scratch/zzeng/pseudomonasProject/BlastGene/Blast4/results/effectorTable.txt" (with quotations marks) in the first row and replace "effectorTable.txt" in Line 26 to be output_file_path without quotation marks.

def createTable(path):
	table = []
	effectorSet = set()
	uniqueEffectors = []
	for d in os.listdir(path):
		for f in os.listdir(os.path.join(path,d)):
			with open(os.path.join(os.path.join(path,d),f), 'r') as fi:
				data = [x.strip().split() for x in fi.readlines()]
				for x in data:
	 				effectorSet.add(re.sub(r'[a-z]*_[0-9]', '', "_".join(x[0].split("_")[-2:])))
	uniqueEffectors = list(effectorSet)
	uniqueEffectors.insert(0, "Strain name")
	uniqueEffectors.append("Total")
	table.append("\t".join(uniqueEffectors))
	strainEffectors = []
	for d in os.listdir(path):
		strainEffectors.append(d)
		c = 0
		for f in os.listdir(os.path.join(path,d)):
			with open(os.path.join(os.path.join(path,d),f), 'r') as fi, open("effectorTable.txt", 'w') as fii:
				data = [x.strip().split() for x in fi.readlines()]
				for i in uniqueEffectors[1:-1]:
					found = False 
					for x in data:
						effector = re.sub(r'[a-z]*_[0-9]', '', "_".join(x[0].split("_")[-2:]))
						if i == effector:
							if float(x[2]) >= 99:
								strainEffectors.append("1")
								found = True
								c += 1 
								break 
					if found == False:
						strainEffectors.append("0")
				strainEffectors.append(str(c))
				row = "\t".join(strainEffectors)
				table.append(row)
				strainEffectors = []
				for x in table:
					fii.write(f"{x}\n")
 
def main():
	ap=argparse.ArgumentParser()
	ap.add_argument(
		'--path',
		type = str, 
		required = True, 
		help = 'path to dirs contaning blast results'
		)
	parse = ap.parse_args()
	createTable(parse.path)
 
if __name__ == "__main__":
	import os,argparse,re
	main()
