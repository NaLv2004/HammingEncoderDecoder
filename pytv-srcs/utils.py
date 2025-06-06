import os
import subprocess
import shutil

def run_iverilog_flow(folder_path):
    # 设置目标工作目录
    target_dir = folder_path   #r"D:\\ChannelCoding\\AutoGen\\Verilog\\Pipelined-Microprogrammed-CPU\\RTL_GEN_0524"
    
    try:
        # 1. 切换工作目录
        os.chdir(target_dir)
        print(f"Switched to directory: {os.getcwd()}")
        
        # 2. 使用iverilog编译
        compile_cmd = ["iverilog", "-o", "wave", "hamming_tb.v"]
        print("Compiling verilog...")
        subprocess.run(compile_cmd, check=True)
        
        # 3. 使用vvp进行仿真
        simulate_cmd = ["vvp", "-n", "wave", "-lxt2"]
        print("Simulating verilog...")
        subprocess.run(simulate_cmd, check=True)
        
        # 4. 使用gtkwave查看波形
        print("Opening waveform file...")
        gtkwave_cmd = ["gtkwave", "wave.vcd"]
        subprocess.Popen(gtkwave_cmd, shell=True)
        
    except FileNotFoundError as e:
        print(f"路径不存在: {e.filename}")
    except subprocess.CalledProcessError as e:
        print(f"命令执行失败: {e.cmd}")
    except Exception as e:
        print(f"发生未知错误: {str(e)}")


def clear_folder(target_dir):
    for item in os.listdir(target_dir):
        item_path = os.path.join(target_dir, item)
        if os.path.isfile(item_path):
            try:
                os.remove(item_path)
                print(f"Deleted: {item_path}")
            except Exception as e:
                print(f"Failed to delete: {item_path} - Error: {e}")
        
        # 如果是子文件夹，递归删除整个目录
        elif os.path.isdir(item_path):
            try:
                shutil.rmtree(item_path)
                print(f"Deleted sub dir: {item_path}")
            except Exception as e:
                print(f"Failed to delete: {item_path} - Error: {e}")
                
                
def gather_file_and_write(folder_path, output_filename):
    file_list = [
        f for f in os.listdir(folder_path)
        if os.path.isfile(os.path.join(folder_path, f)) and f != output_filename
    ]


    with open(os.path.join(folder_path, output_filename), 'w', errors='ignore') as outfile:
        for filename in file_list:
            file_path = os.path.join(folder_path, filename)
            with open(file_path, 'r', errors='ignore') as infile:
                if 'wave' in file_path:
                    continue
                outfile.write(f"// === Contents from: {filename} ===\n")
                outfile.write(infile.read())
                outfile.write("\n\n")  