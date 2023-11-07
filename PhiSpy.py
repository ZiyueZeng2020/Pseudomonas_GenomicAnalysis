#!/bin/sh
'''exec' /mnt/shared/scratch/zzeng/apps/conda/envs/phispy/bin/python "$0" "$@"
' '''
# -*- coding: utf-8 -*-
import re
import sys
from PhiSpyModules.main import run
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(run())
