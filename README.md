# drone-recorder-gopro

В данном образе контейнера представлен сервис, который работает с API камеры GORPO.

Включение записи

def recording(enable):

    rospy.loginfo('Set video enable {0}'.format(enable))

    camera = GoProHero(password='fotokubgopro')
    
    camera.command('record', 'on' if enable else 'off')


Выключение записи

Скачивание записи локально

Помещение записи в IPFS

Данный сервис управляется ROS. 

Все основные команды приходят из контейнера master
