import cupy
import cupyx
print('CuPy says there are / is ' + str(cupy.cuda.runtime.getDeviceCount()) + ' GPU(s).') # will throw an exception if no GPU

import spacy
print('SpaCy require_gpu returns: ' + str(spacy.require_gpu()) + '.') # should be True 
