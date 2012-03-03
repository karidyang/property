#coding:utf-8
Dir["*.txt"].find do |f|
   File.open(f).each_line do |line|
       puts line.scan(/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/)
   end
end
