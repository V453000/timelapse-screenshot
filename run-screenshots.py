import os
from subprocess import Popen
from shutil import copyfile

script_filepath = os.path.realpath(__file__)
script_folder = os.path.dirname(script_filepath)
#save_folder = script_folder + '../../saves/0.17-Built-in-timelapse'
save_folder = os.path.join(script_folder, '..' , '..', 'saves', '0.17-Built-in-timelapse')

# create a copy of control.lua
copied_file_name = 'python-copy-control.lua'
copyfile('control.lua', copied_file_name)

for f in os.listdir(save_folder):
  filename_end = '.zip'
  if f[-len(filename_end):] == filename_end:
    # write into control.lua
    output_file = open('control.lua', 'w')
    with open(copied_file_name, 'r') as control_file:
      all_lines = control_file.readlines()
      for l in all_lines:
        output_line = l
        line_start = 'local timelapse_subfolder = '
        if l[:len(line_start)] == line_start:
          output_line = line_start + '"' + f[:-len(filename_end)] + '"\n'
        output_file.write(output_line)  
    output_file.close()
    
  bin_path = os.path.join(script_folder, '..', '..', 'bin', 'Releasex64vs2017', 'factorio-run.exe')
  process_line = bin_path + ' --benchmark-graphics ' + str(os.path.join('0.17-Built-in-timelapse' , f)) + ' --benchmark-ticks 21'
  process = Popen(process_line)
  process.communicate()

os.remove(copied_file_name)