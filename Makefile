IMAGE = soleo/duckpan:latest

default:
	docker build -t $(IMAGE) .
hack:
	docker run -ti --rm -v `pwd`:/home/ddg -p 5000:5000 $(IMAGE)
push:
	docker push $(IMAGE)