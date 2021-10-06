commit-image:
	git checkout develop
	git add images
	git commit -m "add 新しく画像を引用した．"

commit-push-all: commit-image
	git push
	git checkout main && git merge develop && git push
	git checkout develop
