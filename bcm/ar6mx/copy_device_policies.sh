#!/system/bin/sh
src_path=/system/etc/
tgt_path=/data/system/
dp_file=device_policies.xml

if [ ! -d ${tgt_path} ];
then
busybox printf "creating path %s" "${tgt_path}"
mkdir -p ${tgt_path}
busybox chmod 0750 ${tgt_path}
busybox chown 1000:1000 ${tgt_path}
fi

if [ ! -f ${tgt_path}/device_policies.xml ];
then
busybox printf "copying file %s/%s\n" "${tgt_path}" "${dp_file}"
busybox cp ${src_path}/${dp_file} ${tgt_path}/${dp_file}
busybox chown 1000:1000 ${tgt_path}/${dp_file}
fi
