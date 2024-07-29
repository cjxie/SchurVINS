FROM osrf/ros:noetic-desktop-full-focal

ENV CATKIN_WS /root/catkin_ws

SHELL [ "/bin/bash", "-c"] 

RUN apt-get update -y && \
    apt-get install -y python3-catkin-tools python3-vcstool python3-osrf-pycommon \
    libglew-dev libopencv-dev libyaml-cpp-dev \
    libblas-dev liblapack-dev libsuitesparse-dev \
    git tmux vim libtool libeigen3-dev

COPY ./ ${CATKIN_WS}/src/SchurVINS

WORKDIR ${CATKIN_WS}/src
ENV TERM xterm

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc 
RUN mkdir -p ${CATKIN_WS}/src/SchurVINS/results && \
    mkdir -p ${CATKIN_WS}/src/SchurVINS/logs && \
    vcs-import < ./SchurVINS/dependencies.yaml && \
    touch minkindr/minkindr_python/CATKIN_IGNORE 
RUN apt-get install ros-noetic-rqt-gui -y \
    wget tar
RUN ./SchurVINS/svo_online_loopclosing/vocabularies/download_voc.sh



WORKDIR ${CATKIN_WS}
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \ 
    catkin config --init --mkdirs --cmake-args -DCMAKE_BUILD_TYPE=Release -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3 && \
    catkin build -j6

RUN touch ~/.tmux.conf && \
    echo "setw -g mouse on" >> ~/.tmux.conf

ENTRYPOINT [ "/bin/bash" ]
