# Git学习笔记

## git 工作流程

![1752820176089](git学习记录.assets/1752820176089.png)

### 工作区

就是你在电脑里能看到的目录，比如我的这个test文件夹就是一个工作区：

![1752825293038](git学习记录.assets/1752825293038.png)

### 版本库（Repository）

工作区有一个隐藏目录`.git`，这个不算工作区，而是Git的版本库。

Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支`master`，以及指向`master`的一个指针叫`HEAD`。

![1752825445218](git学习记录.assets/1752825445218.png)

第一步是用`git add`把文件添加进去，实际上就是把文件修改添加到暂存区；

第二步是用`git commit`提交更改，实际上就是把暂存区的所有内容提交到当前分支。

需要提交的文件修改通通放到暂存区，然后，一次性提交暂存区的所有修改。

- 修改readme.txt文件的内容，并新建了一个文件lincens.txt，此时查看版本库的状态：

  ```bash
  $ git status
  On branch sam2
  Your branch is ahead of 'origin/sam2' by 1 commit.
    (use "git push" to publish your local commits)
  
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
          modified:   readme.txt
  
  Untracked files:
    (use "git add <file>..." to include in what will be committed)
          licenes.txt
  
  no changes added to commit (use "git add" and/or "git commit -a")
  ```

  Git非常清楚地告诉我们，`readme.txt`被修改了，而`LICENSE`还从来没有被添加过，所以它的状态是`Untracked`。

  现在，使用两次命令`git add`，把`readme.txt`和`LICENSE`都添加后，用`git status`再查看一下：

  ```bash
  $ git status
  On branch sam2
  Your branch is ahead of 'origin/sam2' by 1 commit.
    (use "git push" to publish your local commits)
  
  Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
          new file:   licenes.txt
          modified:   readme.txt
  ```

  现在，暂存区的状态就变成这样了：

  ![1752826106017](git学习记录.assets/1752826106017.png)

  所以，`git add`命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行`git commit`就可以一次性把暂存区的所有修改提交到分支。

  ```bash
  $ git commit -m 'understand how stage works'
  [sam2 a8cb0c3] understand how stage works
   2 files changed, 3 insertions(+)
   create mode 100644 licenes.txt
  ```

  一旦提交后，如果你又没有对工作区做任何修改，那么工作区就是“干净”的：

  ```bash
  $ git status
  On branch sam2
  Your branch is ahead of 'origin/sam2' by 2 commits.
    (use "git push" to publish your local commits)
  
  nothing to commit, working tree clean
  ```

  现在版本库变成了这样，暂存区就没有任何内容了：

  ![1752826230348](git学习记录.assets/1752826230348.png)

  提交后，用`git diff HEAD -- readme.txt`命令可以查看工作区和版本库里面最新版本的区别：

- 使用`git checkout -- file`可以丢弃工作区的修改：

  ```bash
  $ git checkout -- readme.txt
  ```

  命令`git checkout -- readme.txt`意思就是，把`readme.txt`文件在工作区的修改全部撤销，这里有两种情况：

  一种是`readme.txt`自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；

  一种是`readme.txt`已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。

  总之，就是让这个文件回到最近一次`git commit`或`git add`时的状态。

- 使用 `git restore --staged file` 取消对暂存区的修改：

  ```bash
  $ git status
  On branch sam2
  Your branch is ahead of 'origin/sam2' by 2 commits.
    (use "git push" to publish your local commits)
  
  Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
          modified:   readme.txt
          
  $ git restore --staged readme.txt   #  从暂存区移除，但保留工作区修改
  
  $ git status
  On branch sam2
  Your branch is ahead of 'origin/sam2' by 2 commits.
    (use "git push" to publish your local commits)
  
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
          modified:   readme.txt
  
  no changes added to commit (use "git add" and/or "git commit -a")
  ```

  `git checkout -- file`命令中的`--`很重要，没有`--`，就变成了“切换到另一个分支”的命令

- 如果修改了文件的内容，而且已经 `git add` 到了暂存区，可以使用命令`git reset HEAD <file>`可以把暂存区的修改撤销掉（unstage），重新放回工作区：

  ```bash
  $ git reset HEAD readme.txt
  Unstaged changes after reset:
  M       readme.txt
  ```

  `git reset`命令既可以回退版本，也可以把暂存区的修改回退到工作区。当我们用`HEAD`时，表示最新的版本。

- 使用 `git checkout -- readme.txt` 命令丢弃工作区的修改

## git分支管理



### 创建分支

```bash
git branch <分支名>
git branch jtl/sam2
```

main/master分支应该保留完全稳定的代码——有可能仅仅是已经发布或即将发布的代码

### 切换分支

- 如果有一个分支名叫 branch_a，可以使用 `git checkout branch_a` 来切换到此分支：

  ```bash
  $ git checkout sam2
  Switched to branch 'sam2'
  ```

### 查看分支

- 使用`git branch`获取当前所有分支的列表：

  ```bash
  $ git branch
  * main
    sam2
  ```

  main前面的 `*` 表示当前正处于这个分支，它代表现在检出的那一个分支（也就是说，当前 `HEAD` 指针所指向的分支）。 这意味着如果在这时候提交，`master` 分支将会随着新的工作向前移动。当前一共有两个分支 main 分支和 sam2 分支

- 使用`git branch -r` 查看所有远程分支：

  ```bash
  $ git branch -r
    origin/HEAD -> origin/main
    origin/main
    origin/sam2
  ```

- 使用 git branch -a 查看所有本地分支和远程分支：

  ```bash
  $ git branch -a
  * main
    sam2
    remotes/origin/HEAD -> origin/main
    remotes/origin/main
    remotes/origin/sam2
  ```

- 使用 `git branch -v` 查看每一个分支的最后一次提交信息：

  ```bash
  $ git branch -v
    main c467416 add sam2进行图像分割时，确定地一级参数和二级参数信息
  * sam2 0494210 分支测试文件
  ```

- 如果要查看哪些分支已经合并到当前分支，可以运行 `git branch --merged`：

  ```bash
  $ git branch --merged
    branch_c
  * main
  ```

  因为之前已经合并了 `branch_c` 分支，所以现在看到它在列表中。 在这个列表中分支名字前没有 `*` 号的分支通常可以使用 `git branch -d` 删除掉；你已经将它们的工作整合到了另一个分支，所以并不会失去任何东西。

  ```bash
  $ git branch -d branch_c
  Deleted branch branch_c (was aedeb39).
  ```

- 查看所有包含未合并工作的分支，可以运行 `git branch --no-merged`：

  ```bash
  $ git branch --no-merged
    sam2
  ```

  这里显示了其他分支。 因为它包含了还未合并的工作，尝试使用 `git branch -d` 命令删除它时会失败：

  ```bash
  $ git branch -d sam2
  error: the branch 'sam2' is not fully merged
  hint: If you are sure you want to delete it, run 'git branch -D sam2'
  hint: Disable this message with "git config set advice.forceDeleteBranch f
  ```

  如果真的想要删除分支并丢掉那些工作，如同帮助信息里所指出的，可以使用 `-D` 选项强制删除它。

  检查尚未合并到`main`的分支有哪些（不必在main分支下执行此命令，可以在任何分支下执行此命令）：

  ```bash
  $ git branch --no-merged main
  * sam2
  ```

  

### 删除分支

##### 删除本地分支

- 安全删除（只有该分支被合并后才能成功删除，否则会报错）

  ```bash
  git branch -d 分支名
  ```

- 强制删除（未合并也能够成功删除，通常适用于那些废弃的分支）

  ```bash
  git branch -D 分支名
  ```

##### 删除远程分支

```bash
git push origin --delete branch_name
```

- **原理**：向远程仓库发送删除指令。
- **注意**：需有远程仓库的写入权限。

##### 删除分支后的清理操作

(1) 更新本地的远程分支列表

删除远程分支后，本地仓库仍会保留已删除远程分支的记录（称为 “远程追踪分支”）。使用以下命令清理：

```bash
git fetch -p  # 或 git remote prune origin
```

- `-p` 是 `--prune` 的缩写，会删除本地仓库中已不存在于远程的分支记录。

(2) 查看剩余分支

```bash
git branch -a  # 查看所有分支（本地+远程）
```



使用`git status -s`查看自己 `git add` 了哪些东西：

```bash
(sam2) jtl@DESKTOP-A9875A0:~/embodied_models$ git status -s
A  src/data/tools/sam2/gui/checkpoints/sam2.1_hiera_large.pt
 M src/data/tools/sam2/gui/sam2_gui.py
?? sam2_model_error.txt
?? src/data/tools/sam2/gui/testData/kitti_track_videos/
```

- `A` 表示已添加到暂存区的新文件；
- `M` 表示已添加到暂存区的修改文件；
- `？？`表示是未跟踪（Untracked）：新创建的文件，Git 尚未记录它们。

### 合并分支

- 使用`git merge` 命令将其他分支合并到当前分支：

  ```bash
  git checkout main
  git merge feature-xyz  # 将 feature-xyz 分支合并到了 main 分支
  ```

### 结合合并冲突

当合并过程中出现冲突时，Git 会标记冲突文件，你需要手动解决冲突。

打开冲突文件，按照标记解决冲突。

- 标记冲突解决完成：

  ```bash
  git add <conflict-file>
  ```

- 提交合并结果：

  ```bash
  git commit
  ```


### 版本回退

- 使用`git log`命令查看历史`commit`记录：

  ```bash
  $ git log
  commit 21c6aa1ac666f0a93d89241706c9cc30c17d5635 (HEAD -> sam2)
  Author: TanLin <tanlinji0311@gmail.com>
  Date:   Fri Jul 18 15:01:56 2025 +0800
  
      append GPL
  
  commit d12916798c88265a8621ad418f522ad8d10aec9a (origin/sam2)
  Author: TanLin <tanlinji0311@gmail.com>
  Date:   Fri Jul 18 14:54:30 2025 +0800
  
      this is a test
  
  commit 049421020a513938bda28b54e7ced73314139b33
  Author: TanLin <tanlinji0311@gmail.com>
  Date:   Thu Jul 17 16:41:39 2025 +0800
  
      分支测试文件
  
  commit c467416e8a5fd1d26f9052fee87f83bc1f77afbb
  Author: TanLinJi <tanlinji0311@gmail.com>
  Date:   Mon Jul 14 18:57:11 2025 +0800
  
      add sam2进行图像分割时，确定地一级参数和二级参数信息
  ```

- 可以加上参数 `--pretty=oneline` 简化输出的内容

  ```bash
  $ git log --pretty=oneline
  21c6aa1ac666f0a93d89241706c9cc30c17d5635 (HEAD -> sam2) append GPL
  d12916798c88265a8621ad418f522ad8d10aec9a (origin/sam2) this is a test
  049421020a513938bda28b54e7ced73314139b33 分支测试文件
  c467416e8a5fd1d26f9052fee87f83bc1f77afbb add sam2进行图像分割时，确定地一级参数和二级参数信息
  2aab850f08531e77a8baa0df08031e1800d4064c Create README.md
  20f0d8d0ad00f257f24db02661e6c8ea9b87bbd7 add a new folder
  095b429e223d551378888dc252cae2fcbf484622 connect test for new PC
  9346e585bad07caaf1f304ea870bfe5c6cb8f376 nihao
  bddca81aff5f4359991cc735779eeb40186f451c Delete niuben.txt
  c3862503ead5d075180088372105f26411bc44f8 new file
  c8a4247dd6a848c67f25b09f7f171cc30d8b9440 add a test file
  ```

  - 输入 `q` 键退出查看log日志。
  - 每一行前边的 `21c6aa1ac666f0a93d89241706c9cc30c17d5635` ，这类就是 `commit ID` 版本号
  - 在Git中，用`HEAD`表示当前版本，也就是最新的提交`21c6aa1ac666f0a93d89241706c9cc30c17d5635` 
  - 上一个版本就是 `HEAD^` ，上两个版本就是 `HEAD^^`，回退几个版本就添加几个`^`

- 使用 `git reset --hard HEAD^` 回退到上一个版本

  ```bash
  $ git reset --hard HEAD^
  HEAD is now at d129167 this is a test
  ```

  - 根据刚刚查看的日志，现在版本已经回退到了 `d129167` 
  - `--hard`会回退到上个版本的已提交状态，而`--soft`会回退到上个版本的未提交状态，`--mixed`会回退到上个版本已添加但未提交的状态。

  | 参数      | HEAD | 暂存区 | 工作区 | 危险程度 |
  | --------- | ---- | ------ | ------ | -------- |
  | `--soft`  | ✅    | ❌      | ❌      | 低       |
  | `--mixed` | ✅    | ✅      | ❌      | 中       |
  | `--hard`  | ✅    | ✅      | ✅      | 高       |

- 再次使用 `git log` 查看现在版本库的状态：

  ```bash
  $ git log --pretty=oneline
  d12916798c88265a8621ad418f522ad8d10aec9a (HEAD -> sam2, origin/sam2) this is a test
  049421020a513938bda28b54e7ced73314139b33 分支测试文件
  c467416e8a5fd1d26f9052fee87f83bc1f77afbb add sam2进行图像分割时，确定地一级参数和二级参数信息
  2aab850f08531e77a8baa0df08031e1800d4064c Create README.md
  20f0d8d0ad00f257f24db02661e6c8ea9b87bbd7 add a new folder
  095b429e223d551378888dc252cae2fcbf484622 connect test for new PC
  9346e585bad07caaf1f304ea870bfe5c6cb8f376 nihao
  bddca81aff5f4359991cc735779eeb40186f451c Delete niuben.txt
  c3862503ead5d075180088372105f26411bc44f8 new file
  c8a4247dd6a848c67f25b09f7f171cc30d8b9440 add a test file
  ```

- 如果想要再次回到刚刚的版本，只要命令窗口没有被关掉，找到 `append GPL` 这次提交的 `commit ID`，就可以指定回到那个版本：

  ```bash
  $ git reset --hard 21c6
  HEAD is now at 21c6aa1 append GPL
  ```

  `21c6`是 `append GPL` 这次提交的 `commit ID`的前边几位，只要确定能够和其他的`commit ID`相区分来就可以，可以是使用任意位

  Git的版本回退速度非常快，因为Git在内部有个指向当前版本的`HEAD`指针，当你回退版本的时候，Git仅仅是把HEAD从指向`append GPL`：

  ![1752823822177](git学习记录.assets/1752823822177.png)

  改为指向`add distributed`：

  ![1752823843074](git学习记录.assets/1752823843074.png)

  所以可以理解：每提交一个新版本，实际上Git就会把它们自动串成一条时间线。

- 使用 `git -reflog` 来查看曾经的命令记录：

  ```bash
  $ git reflog
  21c6aa1 (HEAD -> sam2) HEAD@{0}: reset: moving to 21c6
  d129167 (origin/sam2) HEAD@{1}: reset: moving to HEAD^
  21c6aa1 (HEAD -> sam2) HEAD@{2}: commit: append GPL
  d129167 (origin/sam2) HEAD@{3}: commit: this is a test
  0494210 HEAD@{4}: checkout: moving from main to sam2
  aedeb39 (origin/main, origin/HEAD, main) HEAD@{5}: checkout: moving from sam2 to main
  0494210 HEAD@{6}: checkout: moving from main to sam2
  ```

   `append GPL` 这次提交的 `commit ID`是`21c6aa1`，因此总是能回到这个版本

总结：

- `HEAD`指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令`git reset --hard commit_id`。
- 穿梭前，用`git log`可以查看提交历史，以便确定要回退到哪个版本。
- 要重返未来，用`git reflog`查看命令历史，以便确定要回到未来的哪个版本。

### 删除文件

- 使用 `git rm` 从版本库中删除指定的文件，然后需要 `commit` `push`，才能更新到远端仓库。

  ```bash
  $ git rm licenes.txt
  rm 'licenes.txt'
  ```

- 另一种情况是删错了，因为版本库里还有，所以可以很轻松地把误删的文件恢复到最新版本：

  ```bash
  $ git checkout -- licenes.txt
  ```

  