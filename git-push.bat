@echo off
chcp 65001
echo 开始执行 Git 操作...

cd /d E:\HKlearning\前端学习\简历12
git checkout master
git add .
git commit -m "auto commit"
git push origin master

echo Git 操作已完成。
pause 