#!/bin/bash
# lanmp 一键安装脚本

echo "It will install lamp or lnmp."
sleep 1
##check last command is OK or not.
check_ok() {
	if [ $? != 0 ]
	then
    	echo "Error, Check the error log."
    	exit 1
	fi
}
##get the archive of the system,i686 or x86_64.
# arch 输出机器的体系结构 
# 或者  ar=`uname -r |awk -F '.' '{print $NF}'`
ar=`arch`

##close seliux(Need reboot)
selinux_s=`getenforce`
if [ $selinux_s == "Enforcing"  -o $selinux_s == "enforcing" ]
then
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	setenforce 0
fi

##close iptables
# 先备份防火墙规则，备份文件名使用时间戳(S),防止覆盖
iptables-save > /etc/sysconfig/iptables_`date +%s`
iptables -F
service iptables save

##if the packge installed ,then omit.
myum() {
	# "^$1" 以传递的参数（rpm包名）开头的精确匹配
	if ! rpm -qa|grep -q "^$1"
	then
		yum install -y $1
		check_ok
	else
		echo $1 already installed.
	fi
}

## install some packges.
# 一些LANMP依赖包
for p in gcc wget perl perl-devel libaio libaio-devel pcre-devel zlib-devel
do
    myum $p
done

##install epel.
# 卸载yum安装的epel(slow)
#  bug  永远执行
if rpm -qa epel-release >/dev/null
then
    rpm -e epel-release
fi
# 删除可能存在的扩展源文件
if ls /etc/yum.repos.d/epel-6.repo* >/dev/null 2>&1
then
    rm -f /etc/yum.repos.d/epel-6.repo*
fi
# wget -P=--prefix  指定保存文件的的路径前缀
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-6.repo

###########准备工作完成############################################



##function of installing mysqld.
install_mysqld() {
	echo "Chose the version of mysql."
	select mysql_v in 5.1 5.6
	do
    	case $mysql_v in
        5.1)
        	cd /usr/local/src
			# 若存在mysql源码包，直接进行下一步；若不存在，则去下载。---->|| 实现
			# 直接写 [-f ***]条件表达式
        	[ -f mysql-5.1.72-linux-$ar-glibc23.tar.gz ] || wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.72-linux-$ar-glibc23.tar.gz
            tar zxf mysql-5.1.72-linux-$ar-glibc23.tar.gz
            check_ok
			# 若mysql目录已经存在，则备份后删除（时间戳防覆盖）
            [ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_`date +%s`
            mv mysql-5.1.72-linux-$ar-glibc23 /usr/local/mysql
            check_ok
            if ! grep '^mysql:' /etc/passwd
            then
				# -M 不创建用户家目录
                useradd -M mysql -s /sbin/nologin
                check_ok
            fi
            myum compat-libstdc++-33
            [ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_`date +%s`
            mkdir -p /data/mysql
            chown -R mysql:mysql /data/mysql
            cd /usr/local/mysql
            ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
            check_ok
            /bin/cp support-files/my-huge.cnf /etc/my.cnf
            check_ok
			# sed '/匹配/a\新增行' 在匹配项下方新增一行
            sed -i '/^\[mysqld\]$/a\datadir = /data/mysql' /etc/my.cnf
            [ -f /etc/init.d/mysqld ] && /bin/mv /etc/init.d/mysqld /etc/init.d/mysqld_`date +%s`
			/bin/cp support-files/mysql.server /etc/init.d/mysqld
            sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
			sed -i 's#^basedir=#basedir=/usr/local/mysql#'
            chmod 755 /etc/init.d/mysqld
            chkconfig --add mysqld
            chkconfig mysqld on
            service mysqld start
            check_ok
            break
            ;;
        5.6)
            cd /usr/local/src
            [ -f mysql-5.6.30-linux-glibc2.5-$ar.tar.gz ] || wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.30-linux-glibc2.5-$ar.tar.gz 
            tar zxf mysql-5.6.30-linux-glibc2.5-$ar.tar.gz
            check_ok
            [ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_`date +%s`
            mv mysql-5.6.30-linux-glibc2.5-$ar /usr/local/mysql
            if ! grep '^mysql:' /etc/passwd
            then
                useradd -M mysql -s /sbin/nologin
            fi
            myum compat-libstdc++-33
            [ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_`date +%s`
            mkdir -p /data/mysql
            chown -R mysql:mysql /data/mysql
            cd /usr/local/mysql
            ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
            check_ok
            /bin/cp support-files/my-default.cnf /etc/my.cnf
            check_ok
            sed -i '/^\[mysqld\]$/a\datadir = /data/mysql' /etc/my.cnf
	    	[ -f /etc/init.d/mysqld ] && /bin/mv /etc/init.d/mysqld /etc/init.d/mysqld_`date +%s`			
            /bin/cp support-files/mysql.server /etc/init.d/mysqld
            sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
	    	sed -i 's#^basedir=#basedir=/usr/local/mysql#'
            chmod 755 /etc/init.d/mysqld
            chkconfig --add mysqld
            chkconfig mysqld on
            service mysqld start
            check_ok
            break
            ;;
         *)
            echo "only 1(5.1) or 2(5.6)"
            #exit 1
            ;;
    	esac
	done
}

##function of install httpd.
install_httpd() {
	echo "Install apache version 2.2."
	cd /usr/local/src
	[ -f httpd-2.2.31.tar.gz ] || wget  http://mirrors.cnnic.cn/apache/httpd/httpd-2.2.31.tar.gz
	check_ok
	tar zxf  httpd-2.2.31.tar.gz && cd httpd-2.2.31
	check_ok
	./configure \
	--prefix=/usr/local/apache2 \
	--with-included-apr \
	--enable-so \
	--enable-deflate=shared \
	--enable-expires=shared \
	--enable-rewrite=shared \
	--with-pcre
	check_ok
	make && make install
	check_ok
	
	#添加apache启动项
	[ -f /etc/init.d/httpd ] && /bin/mv /etc/init.d/httpd /etc/init.d/httpd_`date +%s`
	cp /usr/local/apache2/bin/apachectl /etc/init.d/httpd 
	check_ok
	# bug--> apache2.2 的apachectl启动脚本里面的shell解释器为/bin/sh
	sed -i '\#!/bin/sh#a\\# chkconfig: 2435 85 15\n\# description: Apache script to start and stop' /etc/init.d/httpd
	check_ok
	chmod 755 /etc/init.d/httpd
	chkconfig --add httpd
	chkconfig httpd on
	service httpd start
	check_ok
}

##Compile php function
php_compile() {
	#安装依赖包
	for p in openssl-devel bzip2-devel \
              libxml2-devel curl-devel libpng-devel \
              libjpeg-devel freetype-devel libmcrypt-devel\
              libtool-ltdl-devel perl-devel
	do
		myum $p
		check_ok
	done

    	./configure \
        --prefix=/usr/local/php \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --with-config-file-path=/usr/local/php/etc  \
        --with-mysql=/usr/local/mysql \
        --with-libxml-dir \
        --with-gd \
        --with-jpeg-dir \
        --with-png-dir \
        --with-freetype-dir \
        --with-iconv-dir \
        --with-zlib-dir \
		--with-bz2 \
        --with-openssl \
        --with-mcrypt \
        --enable-soap \
        --enable-gd-native-ttf \
        --enable-mbstring \
        --enable-sockets \
        --enable-exif \
        --disable-ipv6
        check_ok
        make && make install
		check_ok
}

##function of install lamp's php.
install_php() {
	echo -e "Install php.\nPlease chose the version of php."
	select php_v in 5.4 5.6
	do
		case $php_v in
        5.4)
        	cd /usr/local/src/
	    	# wget -O 指定下载文件保存名(--output)
            [ -f php-5.4.45.tar.bz2 ] || wget 'http://cn2.php.net/get/php-5.4.45.tar.bz2/from/this/mirror' -O php-5.4.45.tar.bz2
            tar jxf php-5.4.45.tar.bz2 && cd php-5.4.45
 
            # 调用php编译函数
			php_compile 

            [ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production  /usr/local/php/etc/php.ini
	        # select 语句不能自行跳出
            break
            ;;
        5.6)
            cd /usr/local/src/
            [ -f php-5.6.6.tar.gz ] || wget http://mirrors.sohu.com/php/php-5.6.6.tar.gz
            tar zxf php-5.6.6.tar.gz &&   cd php-5.6.6
            
			# 调用php编译函数
			php_compile 
            
			[ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production  /usr/local/php/etc/php.ini
            break
            ;;

        *) #输入非1/2时，重新输入
            echo "only 1(5.4) or 2(5.6)"
            ;;
    	esac
	done
}

##function of apache and php configue.
# 配置apache以支持php解析
join_apa_php() {
	# 给httpd.conf添加 AddType application/x-httpd-php .php 
	sed -i '/AddType .*.gz .tgz$/a\AddType application\/x-httpd-php .php' /usr/local/apache2/conf/httpd.conf
	check_ok
	# 给apache添加index.php 以支持php解析
	sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html index.htm/' /usr/local/apache2/conf/httpd.conf
	check_ok
	# cat 一段内容到指定文件，EOF之间要添加的内容
    cat > /usr/local/apache2/htdocs/index.php <<EOF
<?php
	phpinfo();
?>
EOF

	if /usr/local/php/bin/php -i |grep -iq 'date.timezone => no value'
	then
		# 配置php dat.timezone
 	    sed -i '/;date.timezone =$/a\date.timezone = "Asia\/Shanghai"'  /usr/local/php/etc/php.ini
	fi
	
	#重启apache，使配置文件生效
	service httpd restart
	check_ok
}

##if the php has been installed，then omitted it.
check_php() {
	if [ -f /usr/local/php/etc/php.ini ]
	then
		echo "PHP has already installed."
	else
		install_php
	fi
}

##function of check service is running or not, example nginx, httpd, php-fpm.
# 检查服务是否启动
check_service() {
	# 先挑出php-fpm
	if [ "$1" == "phpfpm" ]
	then
  		# shell函数名不能出现 '-', 非法字符
    	s="php-fpm"
	else
     	s=$1
  	fi
    # 单独判断LAMP-php是否安装
	if [ "$1" == "php" ]
        then
	    check_php
	else		
		n=`ps aux |grep "$s"|wc -l`
		if [ $n -gt 1 ]
		then
   			echo "$1 service has already started."
		else
			# 防止再次安装已经安装但没有启动的服务
    		if [ -f /etc/init.d/$1 ]
    		then
        		/etc/init.d/$1 start
        		check_ok
    		else
        		install_$1
 		   	fi
		fi
	fi
}

##function of install lamp
lamp() {
	# mysqld httpd 先安装
	check_service mysqld
	check_service httpd
	# php 最后安装
	check_service php
	#apache 结合php
	join_apa_php
	echo "LAMP done，Please use 'http://your ip/index.php' to access."
}

##function of install nginx
install_nginx() {
	cd /usr/local/src
	[ -f nginx-1.8.0.tar.gz ] || wget http://nginx.org/download/nginx-1.8.0.tar.gz
	tar zxf nginx-1.8.0.tar.gz
	cd nginx-1.8.0
	myum pcre-devel
	./configure --prefix=/usr/local/nginx
	check_ok
	make && make install
	check_ok

	#配置
	if [ -f /etc/init.d/nginx ]
	then
    	/bin/mv /etc/init.d/nginx  /etc/init.d/nginx_`date +%s`
	fi
	# nginx 启动脚本需要手动创建
	curl http://www.apelearn.com/study_v2/.nginx_init  -o /etc/init.d/nginx
	check_ok
	chmod 755 /etc/init.d/nginx
	chkconfig --add nginx
	chkconfig nginx on

	if [ -f /usr/local/nginx/conf/nginx.conf ]
	then
		/bin/mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf_`date +%s`
	fi
	# 重新写配置文件
	curl http://www.apelearn.com/study_v2/.nginx_conf -o /usr/local/nginx/conf/nginx.conf
	check_ok
	service nginx start
	check_ok
	echo -e "<?php\n    phpinfo();\n?>" > /usr/local/nginx/html/index.php
	check_ok
}

##function of install php-fpm
install_phpfpm() {
	echo -e "Install php.\nPlease chose the version of php."
	select php_v in 5.4 5.6
	do
    	case $php_v in
        5.4)
            cd /usr/local/src/
            [ -f php-5.4.45.tar.bz2 ] || wget 'http://cn2.php.net/get/php-5.4.45.tar.bz2/from/this/mirror' -O php-5.4.45.tar.bz2
            tar jxf php-5.4.45.tar.bz2 && cd php-5.4.45
            for p in  openssl-devel bzip2-devel \
            libxml2-devel curl-devel libpng-devel \
            libjpeg-devel freetype-devel libmcrypt-devel\
            libtool-ltdl-devel perl-devel
            do
                myum $p
            done
            if ! grep -q '^php-fpm:' /etc/passwd
            then
                useradd -M -s /sbin/nologin php-fpm
                check_ok
            fi
            ./configure \
			# php-fpm :php Fastcgi process manager
            --prefix=/usr/local/php-fpm \
            --with-config-file-path=/usr/local/php-fpm/etc \
            --enable-fpm \
            --with-fpm-user=php-fpm \
            --with-fpm-group=php-fpm \
            --with-mysql=/usr/local/mysql \
            --with-mysql-sock=/tmp/mysql.sock \
            --with-libxml-dir \
            --with-gd \
            --with-jpeg-dir \
            --with-png-dir \
            --with-freetype-dir \
            --with-iconv-dir \
            --with-zlib-dir \
            --with-mcrypt \
            --enable-soap \
            --enable-gd-native-ttf \
            --enable-ftp \
			[ -f /etc/init.d/phpfpm ] || /bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/phpfpm
			check_ok
            chmod 755 /etc/init.d/phpfpm
            chkconfig phpfpm on
            service phpfpm start
            check_ok
            break
            ;;
        5.6)
            cd /usr/local/src/
            [ -f php-5.6.6.tar.gz ] || wgept http://mirrors.sohu.com/php/php-5.6.6.tar.gz

            tar zxf php-5.6.6.tar.gz &&   cd php-5.6.6
            for p in  openssl-devel bzip2-devel \
            libxml2-devel curl-devel libpng-devel \
            libjpeg-devel freetype-devel libmcrypt-devel\
            libtool-ltdl-devel perl-devel
            do
                myum $p
            done

            if ! grep -q '^php-fpm:' /etc/passwd
            then
                useradd -M -s /sbin/nologin php-fpm
            	check_ok
            fi

            ./configure \
            --prefix=/usr/local/php-fpm \
            --with-config-file-path=/usr/local/php-fpm/etc \
            --enable-fpm \
            --with-fpm-user=php-fpm \
            --with-fpm-group=php-fpm \
            --with-mysql=/usr/local/mysql \
            --with-mysql-sock=/tmp/mysql.sock \
            --with-libxml-dir \
            --with-gd \
            --with-jpeg-dir \
            --with-png-dir \
            --with-freetype-dir \
            --with-iconv-dir \
            --with-zlib-dir \
            --with-mcrypt \
            --enable-soap \
            --enable-gd-native-ttf \
            --enable-ftp \
            --enable-mbstring \
            --enable-exif \
            --disable-ipv6 \
            --with-pear \
            --with-curl \
            --with-openssl
            check_ok
            make && make install
            check_ok
            [ -f /usr/local/php-fpm/etc/php.ini ] || /bin/cp php.ini-production  /usr/local/php-fpm/etc/php.ini
            if /usr/local/php-fpm/bin/php -i |grep -iq 'date.timezone => no value'
            then
                sed -i '/;date.timezone =$/a\date.timezone = "Asia\/Shanghai"'  /usr/local/php-fpm/etc/php.ini
                check_ok
            fi
            [ -f /usr/local/php-fpm/etc/php-fpm.conf ] || curl http://www.apelearn.com/study_v2/.phpfpm_conf -o /usr/local/php-fpm/etc/php-fpm.conf
            check_ok
            [ -f /etc/init.d/phpfpm ] || /bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/phpfpm
            chmod 755 /etc/init.d/phpfpm
            chkconfig phpfpm on
            service phpfpm start
            check_ok
            break
            ;;

        *)
            echo 'only 1(5.4) or 2(5.6)'
            ;;
    	esac
done
}

##function of install lnmp
lnmp() {
	check_service mysqld
	check_service nginx
	check_service phpfpm
	echo "The lnmp done, Please use 'http://your ip/index.php' to access."
}

##function of enter
while true
do
	read -p "Please chose which type env you install, (lamp|lnmp)? " t
	case $t in
   		lamp)
        	lamp;exit 1
  			;;
	    lnmp)
	        lnmp;exit 1
	        ;;
	    *)
    	    echo "Only 'lamp' or 'lnmp' your can input."
        	;;
	esac
done
