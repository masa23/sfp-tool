import time
import subprocess
import RPi.GPIO as GPIO

# BCM(GPIO番号)で指定する設定
GPIO.setmode(GPIO.BCM)

# GPIO6を出力モード（LED用）、GPIO26を入力モード（タクトスイッチ用）に設定
time.sleep(1)
GPIO.setup(6, GPIO.OUT)
GPIO.setup(6,0)
GPIO.setup(26, GPIO.IN)

def check_i2c_addresses():
    # `i2cdetect`コマンドを実行して結果を取得
    result = subprocess.check_output(['i2cdetect', '-y', '1'])
    return ' 50 ' in result.decode() and ' 51 ' in result.decode()


try:
    while True:
        # I2Cデバイスが見つかったかチェック
        if check_i2c_addresses():
            # LEDを点灯
            print("SFP connectied")
            GPIO.output(6, 1)
           
            while True:
                if GPIO.input(26) == GPIO.HIGH: 
                    print("Push Button")
                    # EEPROM Flush を実行
                    result = subprocess.run(['/usr/bin/ruby', 'rewrite.rb'])
                    if result.returncode != 0:
                        print("Error: EEPROM flush failed.")
                        break
                    else:
                        GPIO.output(6, 0)
                        break

                if not check_i2c_addresses():
                    break
            time.sleep(0.2)
            
            # I2Cデバイスが消えるのを待つ
            while check_i2c_addresses():
                time.sleep(0.5)

            print("SFP disconnected")
            GPIO.output(6, 0)

except KeyboardInterrupt:
    # プログラムが中断された場合、GPIOをクリーンアップ
    GPIO.cleanup()
