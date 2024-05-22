FROM ubuntu
ENV TZ=Europe/Moscow
RUN apt-get clean && apt-get update -y 
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata git sudo build-essential autoconf libtool libssl-dev zlib1g-dev librdkafka-dev pkg-config cmake gcc git g++ mysql-client libmysqlclient-dev libboost-all-dev libssl-dev && apt-get clean
RUN git clone -b main https://github.com/pocoproject/poco.git && cd poco && mkdir cmake-build && cd cmake-build && cmake .. && make && sudo make install && cd .. && cd ..
ARG build1=$RANDOM
RUN git clone https://github.com/NastyaZorro169/architecture_labs.git
RUN sudo ldconfig
RUN cd architecture_labs/ServiceOrder/OrderService && mkdir build && cd build && cmake  .. && make
ENTRYPOINT [ "architecture_labs/ServiceOrder/OrderService/build/OrderService" ]
