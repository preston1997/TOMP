"""
主程序
"""

from scheduler import Scheduler
import time
import sys
import msvcrt
import threading
import logging

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')


def main():
    # 初始化定时任务
    scheduler = Scheduler("mysql+mysqlconnector://root:night0524@localhost:3306/ry")
    scheduler.start()

    # 输入缓冲区（确保在函数作用域内初始化）
    input_buffer = []  # <--- 关键修复点
    logging.info("程序已启动，输入 'run' 并回车手动触发订单分配...")

    try:
        while True:
            # 非阻塞检测键盘输入
            if msvcrt.kbhit():
                char = msvcrt.getch()
                try:
                    char_decoded = char.decode('gbk').lower()
                except:
                    continue

                if char_decoded == '\r':
                    cmd = ''.join(input_buffer).strip()
                    input_buffer = []  # 清空缓冲区
                    print()
                    if cmd == "run":
                        logging.info("手动触发订单分配...")
                        thread = threading.Thread(target=scheduler.run_optimization)
                        thread.start()
                        logging.info("优化线程已启动，请查看日志确认进度。")
                    else:
                        logging.warning(f"未知命令: {cmd}")
                elif char_decoded == '\x08':  # 退格键
                    if input_buffer:
                        input_buffer.pop()
                        sys.stdout.write('\b \b')
                        sys.stdout.flush()
                else:
                    input_buffer.append(char_decoded)
                    sys.stdout.write(char_decoded)
                    sys.stdout.flush()

            time.sleep(0.1)
    except KeyboardInterrupt:
        scheduler.scheduler.shutdown()

if __name__ == "__main__":
    main()

