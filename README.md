#GOPRO.PY
Данный фаил содежит в себе набор готовых функций и процедур, созданный специально для управление работой камеры GoPro.

Данные методы в дальнейшем для проекта вызываются из соседних контейнеров специализированными ROS-запросами.

Основной метод в модуле:

 ```def handle_record(msg)``` - данный метод используется для запуска основной процедуры записи, и публикации в ipfs.

В начале метода мы проверяем значение на содержание значения

```Python
...

if msg.data:
            # Start recording the video
            try:
                recording(True)
                return SetBoolResponse(True, '')
            except:
                return SetBoolResponse(False, 'Unable to start recording')

...
```

и решаем о старте, либо остановке записи на камере. Заметим, что запуск записи камеры производится без каких либо дополнительных действий. 
###### Метод ```recording()``` будет описан ниже. 

Далее обратим внимание на то, что происходит при остановке записи:

```Python
...

else:
            # Stop recording and publish thumbnail & video files
            try:
                recording(False)
            except Exception as e:
                return SetBoolResponse(False, 'Unable to stop recording: {0}'.format(e))

            thumbhash = ''
            try:
                time.sleep(2)
                m = list(medias())[-1]
                msg = String()

                thumbhash = ipfsPublish(getThumb(m))
                msg.data = thumbhash
                thumbnail.publish(msg)

                videohash = ipfsPublish(getVideo(m))
                msg.data = videohash
                video.publish(msg)
            except Exception as e:
                return SetBoolResponse(False, 'Unable to publish media: {0}'.format(e))

            return SetBoolResponse(True, videohash)

...
```

Данный код можно разбить на следующий набор методов:

 - ```recording()``` - данный метод занимается двумя действиями: удаление всех файлов с камеры, управление затвором камеры.
 - - Рассмотрим данный модуль:
 
 ```Python
 def recording(enable):
    rospy.loginfo('Set video enable {0}'.format(enable))
    camera = GoProHero(password='password')
    try:
       if enable:
         urlopen('http://10.5.5.9/gp/gpControl/command/storage/delete/all').read()
         time.sleep(5)
    except:
       rospy.loginfo('FORMATTING FAIL')
    camera.command('record', 'on' if enable else 'off')
 ```
 
 Заметим, что  в начале мы создаем объект ```camera = GoProHero(password='password')```, обладающий набором методов из API GoPro. Далее производим удаление всех файлов с камеры, для устранения дальнейших трудностей при работе с файловой системой GoPro.  

``` Python
 urlopen('http://10.5.5.9/gp/gpControl/command/storage/delete/all').read()
 time.sleep(5)
```  
 
Заметим что после удаления мы вызываем метод ```sleep``` для возможности ожидания форматирования камеры.

И далее вызывем метод обекта ```camera.command()```

``` Python
 camera.command('record', 'on' if enable else 'off')
``` 

 - ```medias()``` - данный метод предназначен для возврата списка всех медиа-файлов, находящихся на камере.
 - - Рассмотрим данный модуль:

 ```Python
 def medias():
    '''
        Get media list by GoPro HTTP API
    '''
    url ='http://10.5.5.9:8080/gp/gpMediaList'
    media = json.loads(urlopen(url).read())
    for m in media['media']:
        for n in m['fs']:
            rospy.loginfo('Acuired media {0}'.format(m['d']))
            yield '{0}/{1}'.format(m['d'], n['n'])
```

Данный метод расшифровывает JSON файл, полученный от камеры, содержащий структуру файловой системы, с корректным расположением мультимедийных файлов GoPro. Метод является генератором.

 - ```getVideo()```
 - - Рассмотрим данный модуль:
 
 ```Python
 def getVideo(media):
    '''
        Get video by GoPro
    '''
    rospy.loginfo('Get video of {0}'.format(media))
    url = 'http://10.5.5.9:8080/videos/DCIM/{0}'.format(media)
    video = urlopen(url)
    filename = 'test.mp4'
    with open(filename,'wb') as output:
        output.write(video.read())
    return filename
 ```
 
Данный метод скачивает файл с камеры и возвращает его имя.
 
 - ```ipfsPublish()``` - данный метод публикует сохраненный фаил в планетарную систему IPFS.
 
 - - Рассмотрим данный модуль:
 
```Python
def ipfsPublish(data):
    '''
        Publish bytes by IPFS client
    '''
    rospy.loginfo('IPFS publish data length {0}'.format(len(data)))
    return ipfsapi.connect('127.0.0.1', 5001).add(data)['Hash']
```

Заметим, что данный метод использует ```IPFS_API``` и публикует ранее скаченный фаил, возвращая Hash, который является частью ссылки в ```http://ipfs.io/ipfs/```

Выгрузка производится относительно быстро, так как файл будет сразу же доступен для скачивания.





