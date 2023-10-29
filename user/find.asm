
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"
#include "user/user.h"

void
find(char *path, char *file)
{
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	0500                	addi	s0,sp,640
  2a:	892a                	mv	s2,a0
  2c:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, 0)) < 0) {
  2e:	4581                	li	a1,0
  30:	00000097          	auipc	ra,0x0
  34:	540080e7          	jalr	1344(ra) # 570 <open>
  38:	10054063          	bltz	a0,138 <find+0x138>
  3c:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot find path %s\n", path);
    exit(1);
  }

  if (fstat(fd, &st) < 0) {
  3e:	d8840593          	addi	a1,s0,-632
  42:	00000097          	auipc	ra,0x0
  46:	546080e7          	jalr	1350(ra) # 588 <fstat>
  4a:	10054663          	bltz	a0,156 <find+0x156>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    exit(1);
  }

  if (st.type != T_DIR) {
  4e:	d9041703          	lh	a4,-624(s0)
  52:	4785                	li	a5,1
  54:	12f71563          	bne	a4,a5,17e <find+0x17e>
    fprintf(2, "find: %s is not a directory\n", path);
    close(fd);
    exit(1);
  }

  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
  58:	854a                	mv	a0,s2
  5a:	00000097          	auipc	ra,0x0
  5e:	2a8080e7          	jalr	680(ra) # 302 <strlen>
  62:	2541                	addiw	a0,a0,16
  64:	20000793          	li	a5,512
  68:	12a7ef63          	bltu	a5,a0,1a6 <find+0x1a6>
    fprintf(2, "find: path too long\n");
    close(fd);
    exit(1);
  }

  strcpy(buf, path);
  6c:	85ca                	mv	a1,s2
  6e:	db040513          	addi	a0,s0,-592
  72:	00000097          	auipc	ra,0x0
  76:	248080e7          	jalr	584(ra) # 2ba <strcpy>
  p = buf + strlen(buf);
  7a:	db040513          	addi	a0,s0,-592
  7e:	00000097          	auipc	ra,0x0
  82:	284080e7          	jalr	644(ra) # 302 <strlen>
  86:	02051913          	slli	s2,a0,0x20
  8a:	02095913          	srli	s2,s2,0x20
  8e:	db040793          	addi	a5,s0,-592
  92:	993e                	add	s2,s2,a5
  *p++ = '/';
  94:	00190b13          	addi	s6,s2,1
  98:	02f00793          	li	a5,47
  9c:	00f90023          	sb	a5,0(s2)
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (de.inum == 0 || !strcmp(de.name, ".") || !strcmp(de.name, ".."))
  a0:	00001a97          	auipc	s5,0x1
  a4:	a20a8a93          	addi	s5,s5,-1504 # ac0 <malloc+0x15a>
  a8:	00001b97          	auipc	s7,0x1
  ac:	a20b8b93          	addi	s7,s7,-1504 # ac8 <malloc+0x162>
  b0:	da240a13          	addi	s4,s0,-606
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
  b4:	4641                	li	a2,16
  b6:	da040593          	addi	a1,s0,-608
  ba:	8526                	mv	a0,s1
  bc:	00000097          	auipc	ra,0x0
  c0:	48c080e7          	jalr	1164(ra) # 548 <read>
  c4:	47c1                	li	a5,16
  c6:	14f51363          	bne	a0,a5,20c <find+0x20c>
    if (de.inum == 0 || !strcmp(de.name, ".") || !strcmp(de.name, ".."))
  ca:	da045783          	lhu	a5,-608(s0)
  ce:	d3fd                	beqz	a5,b4 <find+0xb4>
  d0:	85d6                	mv	a1,s5
  d2:	8552                	mv	a0,s4
  d4:	00000097          	auipc	ra,0x0
  d8:	202080e7          	jalr	514(ra) # 2d6 <strcmp>
  dc:	dd61                	beqz	a0,b4 <find+0xb4>
  de:	85de                	mv	a1,s7
  e0:	8552                	mv	a0,s4
  e2:	00000097          	auipc	ra,0x0
  e6:	1f4080e7          	jalr	500(ra) # 2d6 <strcmp>
  ea:	d569                	beqz	a0,b4 <find+0xb4>
      continue;
    memmove(p, de.name, DIRSIZ);
  ec:	4639                	li	a2,14
  ee:	da240593          	addi	a1,s0,-606
  f2:	855a                	mv	a0,s6
  f4:	00000097          	auipc	ra,0x0
  f8:	386080e7          	jalr	902(ra) # 47a <memmove>
    p[DIRSIZ] = 0;
  fc:	000907a3          	sb	zero,15(s2)
    if (stat(buf, &st) < 0) {
 100:	d8840593          	addi	a1,s0,-632
 104:	db040513          	addi	a0,s0,-592
 108:	00000097          	auipc	ra,0x0
 10c:	2e2080e7          	jalr	738(ra) # 3ea <stat>
 110:	0a054e63          	bltz	a0,1cc <find+0x1cc>
      fprintf(1, "find: cannot stat %s\n", buf);
      continue;
    }
    if (st.type == T_FILE && !strcmp(de.name, file)) {
 114:	d9041703          	lh	a4,-624(s0)
 118:	4789                	li	a5,2
 11a:	0cf70563          	beq	a4,a5,1e4 <find+0x1e4>
      fprintf(1, "%s\n", buf);
    } else if (st.type == T_DIR) {
 11e:	d9041703          	lh	a4,-624(s0)
 122:	4785                	li	a5,1
 124:	f8f718e3          	bne	a4,a5,b4 <find+0xb4>
      find(buf, file);
 128:	85ce                	mv	a1,s3
 12a:	db040513          	addi	a0,s0,-592
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <find>
 136:	bfbd                	j	b4 <find+0xb4>
    fprintf(2, "find: cannot find path %s\n", path);
 138:	864a                	mv	a2,s2
 13a:	00001597          	auipc	a1,0x1
 13e:	91658593          	addi	a1,a1,-1770 # a50 <malloc+0xea>
 142:	4509                	li	a0,2
 144:	00000097          	auipc	ra,0x0
 148:	736080e7          	jalr	1846(ra) # 87a <fprintf>
    exit(1);
 14c:	4505                	li	a0,1
 14e:	00000097          	auipc	ra,0x0
 152:	3e2080e7          	jalr	994(ra) # 530 <exit>
    fprintf(2, "find: cannot stat %s\n", path);
 156:	864a                	mv	a2,s2
 158:	00001597          	auipc	a1,0x1
 15c:	91858593          	addi	a1,a1,-1768 # a70 <malloc+0x10a>
 160:	4509                	li	a0,2
 162:	00000097          	auipc	ra,0x0
 166:	718080e7          	jalr	1816(ra) # 87a <fprintf>
    close(fd);
 16a:	8526                	mv	a0,s1
 16c:	00000097          	auipc	ra,0x0
 170:	3ec080e7          	jalr	1004(ra) # 558 <close>
    exit(1);
 174:	4505                	li	a0,1
 176:	00000097          	auipc	ra,0x0
 17a:	3ba080e7          	jalr	954(ra) # 530 <exit>
    fprintf(2, "find: %s is not a directory\n", path);
 17e:	864a                	mv	a2,s2
 180:	00001597          	auipc	a1,0x1
 184:	90858593          	addi	a1,a1,-1784 # a88 <malloc+0x122>
 188:	4509                	li	a0,2
 18a:	00000097          	auipc	ra,0x0
 18e:	6f0080e7          	jalr	1776(ra) # 87a <fprintf>
    close(fd);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	3c4080e7          	jalr	964(ra) # 558 <close>
    exit(1);
 19c:	4505                	li	a0,1
 19e:	00000097          	auipc	ra,0x0
 1a2:	392080e7          	jalr	914(ra) # 530 <exit>
    fprintf(2, "find: path too long\n");
 1a6:	00001597          	auipc	a1,0x1
 1aa:	90258593          	addi	a1,a1,-1790 # aa8 <malloc+0x142>
 1ae:	4509                	li	a0,2
 1b0:	00000097          	auipc	ra,0x0
 1b4:	6ca080e7          	jalr	1738(ra) # 87a <fprintf>
    close(fd);
 1b8:	8526                	mv	a0,s1
 1ba:	00000097          	auipc	ra,0x0
 1be:	39e080e7          	jalr	926(ra) # 558 <close>
    exit(1);
 1c2:	4505                	li	a0,1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	36c080e7          	jalr	876(ra) # 530 <exit>
      fprintf(1, "find: cannot stat %s\n", buf);
 1cc:	db040613          	addi	a2,s0,-592
 1d0:	00001597          	auipc	a1,0x1
 1d4:	8a058593          	addi	a1,a1,-1888 # a70 <malloc+0x10a>
 1d8:	4505                	li	a0,1
 1da:	00000097          	auipc	ra,0x0
 1de:	6a0080e7          	jalr	1696(ra) # 87a <fprintf>
      continue;
 1e2:	bdc9                	j	b4 <find+0xb4>
    if (st.type == T_FILE && !strcmp(de.name, file)) {
 1e4:	85ce                	mv	a1,s3
 1e6:	da240513          	addi	a0,s0,-606
 1ea:	00000097          	auipc	ra,0x0
 1ee:	0ec080e7          	jalr	236(ra) # 2d6 <strcmp>
 1f2:	f515                	bnez	a0,11e <find+0x11e>
      fprintf(1, "%s\n", buf);
 1f4:	db040613          	addi	a2,s0,-592
 1f8:	00001597          	auipc	a1,0x1
 1fc:	8d858593          	addi	a1,a1,-1832 # ad0 <malloc+0x16a>
 200:	4505                	li	a0,1
 202:	00000097          	auipc	ra,0x0
 206:	678080e7          	jalr	1656(ra) # 87a <fprintf>
 20a:	b56d                	j	b4 <find+0xb4>
    }
  }
  close(fd);
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	34a080e7          	jalr	842(ra) # 558 <close>
}
 216:	27813083          	ld	ra,632(sp)
 21a:	27013403          	ld	s0,624(sp)
 21e:	26813483          	ld	s1,616(sp)
 222:	26013903          	ld	s2,608(sp)
 226:	25813983          	ld	s3,600(sp)
 22a:	25013a03          	ld	s4,592(sp)
 22e:	24813a83          	ld	s5,584(sp)
 232:	24013b03          	ld	s6,576(sp)
 236:	23813b83          	ld	s7,568(sp)
 23a:	28010113          	addi	sp,sp,640
 23e:	8082                	ret

0000000000000240 <main>:

int
main(int argc, char *argv[])
{
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
  if (argc < 2 || argc > 3) {
 248:	ffe5069b          	addiw	a3,a0,-2
 24c:	4705                	li	a4,1
 24e:	02d76463          	bltu	a4,a3,276 <main+0x36>
 252:	87ae                	mv	a5,a1
    fprintf(2, "Usage: find (path) [file]\n");
    exit(1);
  } else if (argc < 3) {
 254:	4709                	li	a4,2
 256:	02a74e63          	blt	a4,a0,292 <main+0x52>
    find(".", argv[1]);
 25a:	658c                	ld	a1,8(a1)
 25c:	00001517          	auipc	a0,0x1
 260:	86450513          	addi	a0,a0,-1948 # ac0 <malloc+0x15a>
 264:	00000097          	auipc	ra,0x0
 268:	d9c080e7          	jalr	-612(ra) # 0 <find>
  } else {
    find(argv[1], argv[2]);
  }

  exit(0);
 26c:	4501                	li	a0,0
 26e:	00000097          	auipc	ra,0x0
 272:	2c2080e7          	jalr	706(ra) # 530 <exit>
    fprintf(2, "Usage: find (path) [file]\n");
 276:	00001597          	auipc	a1,0x1
 27a:	86258593          	addi	a1,a1,-1950 # ad8 <malloc+0x172>
 27e:	4509                	li	a0,2
 280:	00000097          	auipc	ra,0x0
 284:	5fa080e7          	jalr	1530(ra) # 87a <fprintf>
    exit(1);
 288:	4505                	li	a0,1
 28a:	00000097          	auipc	ra,0x0
 28e:	2a6080e7          	jalr	678(ra) # 530 <exit>
    find(argv[1], argv[2]);
 292:	698c                	ld	a1,16(a1)
 294:	6788                	ld	a0,8(a5)
 296:	00000097          	auipc	ra,0x0
 29a:	d6a080e7          	jalr	-662(ra) # 0 <find>
 29e:	b7f9                	j	26c <main+0x2c>

00000000000002a0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	f98080e7          	jalr	-104(ra) # 240 <main>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	27e080e7          	jalr	638(ra) # 530 <exit>

00000000000002ba <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c0:	87aa                	mv	a5,a0
 2c2:	0585                	addi	a1,a1,1
 2c4:	0785                	addi	a5,a5,1
 2c6:	fff5c703          	lbu	a4,-1(a1)
 2ca:	fee78fa3          	sb	a4,-1(a5)
 2ce:	fb75                	bnez	a4,2c2 <strcpy+0x8>
    ;
  return os;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	cb91                	beqz	a5,2f4 <strcmp+0x1e>
 2e2:	0005c703          	lbu	a4,0(a1)
 2e6:	00f71763          	bne	a4,a5,2f4 <strcmp+0x1e>
    p++, q++;
 2ea:	0505                	addi	a0,a0,1
 2ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	fbe5                	bnez	a5,2e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2f4:	0005c503          	lbu	a0,0(a1)
}
 2f8:	40a7853b          	subw	a0,a5,a0
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <strlen>:

uint
strlen(const char *s)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 308:	00054783          	lbu	a5,0(a0)
 30c:	cf91                	beqz	a5,328 <strlen+0x26>
 30e:	0505                	addi	a0,a0,1
 310:	87aa                	mv	a5,a0
 312:	4685                	li	a3,1
 314:	9e89                	subw	a3,a3,a0
 316:	00f6853b          	addw	a0,a3,a5
 31a:	0785                	addi	a5,a5,1
 31c:	fff7c703          	lbu	a4,-1(a5)
 320:	fb7d                	bnez	a4,316 <strlen+0x14>
    ;
  return n;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  for(n = 0; s[n]; n++)
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <strlen+0x20>

000000000000032c <memset>:

void*
memset(void *dst, int c, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 332:	ce09                	beqz	a2,34c <memset+0x20>
 334:	87aa                	mv	a5,a0
 336:	fff6071b          	addiw	a4,a2,-1
 33a:	1702                	slli	a4,a4,0x20
 33c:	9301                	srli	a4,a4,0x20
 33e:	0705                	addi	a4,a4,1
 340:	972a                	add	a4,a4,a0
    cdst[i] = c;
 342:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 346:	0785                	addi	a5,a5,1
 348:	fee79de3          	bne	a5,a4,342 <memset+0x16>
  }
  return dst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <strchr>:

char*
strchr(const char *s, char c)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  for(; *s; s++)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cb99                	beqz	a5,372 <strchr+0x20>
    if(*s == c)
 35e:	00f58763          	beq	a1,a5,36c <strchr+0x1a>
  for(; *s; s++)
 362:	0505                	addi	a0,a0,1
 364:	00054783          	lbu	a5,0(a0)
 368:	fbfd                	bnez	a5,35e <strchr+0xc>
      return (char*)s;
  return 0;
 36a:	4501                	li	a0,0
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <strchr+0x1a>

0000000000000376 <gets>:

char*
gets(char *buf, int max)
{
 376:	711d                	addi	sp,sp,-96
 378:	ec86                	sd	ra,88(sp)
 37a:	e8a2                	sd	s0,80(sp)
 37c:	e4a6                	sd	s1,72(sp)
 37e:	e0ca                	sd	s2,64(sp)
 380:	fc4e                	sd	s3,56(sp)
 382:	f852                	sd	s4,48(sp)
 384:	f456                	sd	s5,40(sp)
 386:	f05a                	sd	s6,32(sp)
 388:	ec5e                	sd	s7,24(sp)
 38a:	1080                	addi	s0,sp,96
 38c:	8baa                	mv	s7,a0
 38e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 390:	892a                	mv	s2,a0
 392:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 394:	4aa9                	li	s5,10
 396:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 398:	89a6                	mv	s3,s1
 39a:	2485                	addiw	s1,s1,1
 39c:	0344d863          	bge	s1,s4,3cc <gets+0x56>
    cc = read(0, &c, 1);
 3a0:	4605                	li	a2,1
 3a2:	faf40593          	addi	a1,s0,-81
 3a6:	4501                	li	a0,0
 3a8:	00000097          	auipc	ra,0x0
 3ac:	1a0080e7          	jalr	416(ra) # 548 <read>
    if(cc < 1)
 3b0:	00a05e63          	blez	a0,3cc <gets+0x56>
    buf[i++] = c;
 3b4:	faf44783          	lbu	a5,-81(s0)
 3b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3bc:	01578763          	beq	a5,s5,3ca <gets+0x54>
 3c0:	0905                	addi	s2,s2,1
 3c2:	fd679be3          	bne	a5,s6,398 <gets+0x22>
  for(i=0; i+1 < max; ){
 3c6:	89a6                	mv	s3,s1
 3c8:	a011                	j	3cc <gets+0x56>
 3ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3cc:	99de                	add	s3,s3,s7
 3ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d2:	855e                	mv	a0,s7
 3d4:	60e6                	ld	ra,88(sp)
 3d6:	6446                	ld	s0,80(sp)
 3d8:	64a6                	ld	s1,72(sp)
 3da:	6906                	ld	s2,64(sp)
 3dc:	79e2                	ld	s3,56(sp)
 3de:	7a42                	ld	s4,48(sp)
 3e0:	7aa2                	ld	s5,40(sp)
 3e2:	7b02                	ld	s6,32(sp)
 3e4:	6be2                	ld	s7,24(sp)
 3e6:	6125                	addi	sp,sp,96
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e426                	sd	s1,8(sp)
 3f2:	e04a                	sd	s2,0(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f8:	4581                	li	a1,0
 3fa:	00000097          	auipc	ra,0x0
 3fe:	176080e7          	jalr	374(ra) # 570 <open>
  if(fd < 0)
 402:	02054563          	bltz	a0,42c <stat+0x42>
 406:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 408:	85ca                	mv	a1,s2
 40a:	00000097          	auipc	ra,0x0
 40e:	17e080e7          	jalr	382(ra) # 588 <fstat>
 412:	892a                	mv	s2,a0
  close(fd);
 414:	8526                	mv	a0,s1
 416:	00000097          	auipc	ra,0x0
 41a:	142080e7          	jalr	322(ra) # 558 <close>
  return r;
}
 41e:	854a                	mv	a0,s2
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	64a2                	ld	s1,8(sp)
 426:	6902                	ld	s2,0(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret
    return -1;
 42c:	597d                	li	s2,-1
 42e:	bfc5                	j	41e <stat+0x34>

0000000000000430 <atoi>:

int
atoi(const char *s)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 436:	00054603          	lbu	a2,0(a0)
 43a:	fd06079b          	addiw	a5,a2,-48
 43e:	0ff7f793          	andi	a5,a5,255
 442:	4725                	li	a4,9
 444:	02f76963          	bltu	a4,a5,476 <atoi+0x46>
 448:	86aa                	mv	a3,a0
  n = 0;
 44a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 44c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 44e:	0685                	addi	a3,a3,1
 450:	0025179b          	slliw	a5,a0,0x2
 454:	9fa9                	addw	a5,a5,a0
 456:	0017979b          	slliw	a5,a5,0x1
 45a:	9fb1                	addw	a5,a5,a2
 45c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 460:	0006c603          	lbu	a2,0(a3)
 464:	fd06071b          	addiw	a4,a2,-48
 468:	0ff77713          	andi	a4,a4,255
 46c:	fee5f1e3          	bgeu	a1,a4,44e <atoi+0x1e>
  return n;
}
 470:	6422                	ld	s0,8(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret
  n = 0;
 476:	4501                	li	a0,0
 478:	bfe5                	j	470 <atoi+0x40>

000000000000047a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 480:	02b57663          	bgeu	a0,a1,4ac <memmove+0x32>
    while(n-- > 0)
 484:	02c05163          	blez	a2,4a6 <memmove+0x2c>
 488:	fff6079b          	addiw	a5,a2,-1
 48c:	1782                	slli	a5,a5,0x20
 48e:	9381                	srli	a5,a5,0x20
 490:	0785                	addi	a5,a5,1
 492:	97aa                	add	a5,a5,a0
  dst = vdst;
 494:	872a                	mv	a4,a0
      *dst++ = *src++;
 496:	0585                	addi	a1,a1,1
 498:	0705                	addi	a4,a4,1
 49a:	fff5c683          	lbu	a3,-1(a1)
 49e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a2:	fee79ae3          	bne	a5,a4,496 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
    dst += n;
 4ac:	00c50733          	add	a4,a0,a2
    src += n;
 4b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b2:	fec05ae3          	blez	a2,4a6 <memmove+0x2c>
 4b6:	fff6079b          	addiw	a5,a2,-1
 4ba:	1782                	slli	a5,a5,0x20
 4bc:	9381                	srli	a5,a5,0x20
 4be:	fff7c793          	not	a5,a5
 4c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c4:	15fd                	addi	a1,a1,-1
 4c6:	177d                	addi	a4,a4,-1
 4c8:	0005c683          	lbu	a3,0(a1)
 4cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d0:	fee79ae3          	bne	a5,a4,4c4 <memmove+0x4a>
 4d4:	bfc9                	j	4a6 <memmove+0x2c>

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	ca05                	beqz	a2,50c <memcmp+0x36>
 4de:	fff6069b          	addiw	a3,a2,-1
 4e2:	1682                	slli	a3,a3,0x20
 4e4:	9281                	srli	a3,a3,0x20
 4e6:	0685                	addi	a3,a3,1
 4e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ea:	00054783          	lbu	a5,0(a0)
 4ee:	0005c703          	lbu	a4,0(a1)
 4f2:	00e79863          	bne	a5,a4,502 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f6:	0505                	addi	a0,a0,1
    p2++;
 4f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4fa:	fed518e3          	bne	a0,a3,4ea <memcmp+0x14>
  }
  return 0;
 4fe:	4501                	li	a0,0
 500:	a019                	j	506 <memcmp+0x30>
      return *p1 - *p2;
 502:	40e7853b          	subw	a0,a5,a4
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
  return 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <memcmp+0x30>

0000000000000510 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 510:	1141                	addi	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 518:	00000097          	auipc	ra,0x0
 51c:	f62080e7          	jalr	-158(ra) # 47a <memmove>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 528:	4885                	li	a7,1
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exit>:
.global exit
exit:
 li a7, SYS_exit
 530:	4889                	li	a7,2
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <wait>:
.global wait
wait:
 li a7, SYS_wait
 538:	488d                	li	a7,3
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 540:	4891                	li	a7,4
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <read>:
.global read
read:
 li a7, SYS_read
 548:	4895                	li	a7,5
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <write>:
.global write
write:
 li a7, SYS_write
 550:	48c1                	li	a7,16
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <close>:
.global close
close:
 li a7, SYS_close
 558:	48d5                	li	a7,21
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <kill>:
.global kill
kill:
 li a7, SYS_kill
 560:	4899                	li	a7,6
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <exec>:
.global exec
exec:
 li a7, SYS_exec
 568:	489d                	li	a7,7
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <open>:
.global open
open:
 li a7, SYS_open
 570:	48bd                	li	a7,15
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 578:	48c5                	li	a7,17
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 580:	48c9                	li	a7,18
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 588:	48a1                	li	a7,8
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <link>:
.global link
link:
 li a7, SYS_link
 590:	48cd                	li	a7,19
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 598:	48d1                	li	a7,20
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a0:	48a5                	li	a7,9
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a8:	48a9                	li	a7,10
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b0:	48ad                	li	a7,11
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b8:	48b1                	li	a7,12
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c0:	48b5                	li	a7,13
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c8:	48b9                	li	a7,14
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d0:	1101                	addi	sp,sp,-32
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	addi	s0,sp,32
 5d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5dc:	4605                	li	a2,1
 5de:	fef40593          	addi	a1,s0,-17
 5e2:	00000097          	auipc	ra,0x0
 5e6:	f6e080e7          	jalr	-146(ra) # 550 <write>
}
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	6105                	addi	sp,sp,32
 5f0:	8082                	ret

00000000000005f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f2:	7139                	addi	sp,sp,-64
 5f4:	fc06                	sd	ra,56(sp)
 5f6:	f822                	sd	s0,48(sp)
 5f8:	f426                	sd	s1,40(sp)
 5fa:	f04a                	sd	s2,32(sp)
 5fc:	ec4e                	sd	s3,24(sp)
 5fe:	0080                	addi	s0,sp,64
 600:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 602:	c299                	beqz	a3,608 <printint+0x16>
 604:	0805c863          	bltz	a1,694 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 608:	2581                	sext.w	a1,a1
  neg = 0;
 60a:	4881                	li	a7,0
 60c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 610:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 612:	2601                	sext.w	a2,a2
 614:	00000517          	auipc	a0,0x0
 618:	4ec50513          	addi	a0,a0,1260 # b00 <digits>
 61c:	883a                	mv	a6,a4
 61e:	2705                	addiw	a4,a4,1
 620:	02c5f7bb          	remuw	a5,a1,a2
 624:	1782                	slli	a5,a5,0x20
 626:	9381                	srli	a5,a5,0x20
 628:	97aa                	add	a5,a5,a0
 62a:	0007c783          	lbu	a5,0(a5)
 62e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 632:	0005879b          	sext.w	a5,a1
 636:	02c5d5bb          	divuw	a1,a1,a2
 63a:	0685                	addi	a3,a3,1
 63c:	fec7f0e3          	bgeu	a5,a2,61c <printint+0x2a>
  if(neg)
 640:	00088b63          	beqz	a7,656 <printint+0x64>
    buf[i++] = '-';
 644:	fd040793          	addi	a5,s0,-48
 648:	973e                	add	a4,a4,a5
 64a:	02d00793          	li	a5,45
 64e:	fef70823          	sb	a5,-16(a4)
 652:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 656:	02e05863          	blez	a4,686 <printint+0x94>
 65a:	fc040793          	addi	a5,s0,-64
 65e:	00e78933          	add	s2,a5,a4
 662:	fff78993          	addi	s3,a5,-1
 666:	99ba                	add	s3,s3,a4
 668:	377d                	addiw	a4,a4,-1
 66a:	1702                	slli	a4,a4,0x20
 66c:	9301                	srli	a4,a4,0x20
 66e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 672:	fff94583          	lbu	a1,-1(s2)
 676:	8526                	mv	a0,s1
 678:	00000097          	auipc	ra,0x0
 67c:	f58080e7          	jalr	-168(ra) # 5d0 <putc>
  while(--i >= 0)
 680:	197d                	addi	s2,s2,-1
 682:	ff3918e3          	bne	s2,s3,672 <printint+0x80>
}
 686:	70e2                	ld	ra,56(sp)
 688:	7442                	ld	s0,48(sp)
 68a:	74a2                	ld	s1,40(sp)
 68c:	7902                	ld	s2,32(sp)
 68e:	69e2                	ld	s3,24(sp)
 690:	6121                	addi	sp,sp,64
 692:	8082                	ret
    x = -xx;
 694:	40b005bb          	negw	a1,a1
    neg = 1;
 698:	4885                	li	a7,1
    x = -xx;
 69a:	bf8d                	j	60c <printint+0x1a>

000000000000069c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 69c:	7119                	addi	sp,sp,-128
 69e:	fc86                	sd	ra,120(sp)
 6a0:	f8a2                	sd	s0,112(sp)
 6a2:	f4a6                	sd	s1,104(sp)
 6a4:	f0ca                	sd	s2,96(sp)
 6a6:	ecce                	sd	s3,88(sp)
 6a8:	e8d2                	sd	s4,80(sp)
 6aa:	e4d6                	sd	s5,72(sp)
 6ac:	e0da                	sd	s6,64(sp)
 6ae:	fc5e                	sd	s7,56(sp)
 6b0:	f862                	sd	s8,48(sp)
 6b2:	f466                	sd	s9,40(sp)
 6b4:	f06a                	sd	s10,32(sp)
 6b6:	ec6e                	sd	s11,24(sp)
 6b8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ba:	0005c903          	lbu	s2,0(a1)
 6be:	18090f63          	beqz	s2,85c <vprintf+0x1c0>
 6c2:	8aaa                	mv	s5,a0
 6c4:	8b32                	mv	s6,a2
 6c6:	00158493          	addi	s1,a1,1
  state = 0;
 6ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6cc:	02500a13          	li	s4,37
      if(c == 'd'){
 6d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6d4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6d8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6dc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e0:	00000b97          	auipc	s7,0x0
 6e4:	420b8b93          	addi	s7,s7,1056 # b00 <digits>
 6e8:	a839                	j	706 <vprintf+0x6a>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	ee2080e7          	jalr	-286(ra) # 5d0 <putc>
 6f6:	a019                	j	6fc <vprintf+0x60>
    } else if(state == '%'){
 6f8:	01498f63          	beq	s3,s4,716 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6fc:	0485                	addi	s1,s1,1
 6fe:	fff4c903          	lbu	s2,-1(s1)
 702:	14090d63          	beqz	s2,85c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 706:	0009079b          	sext.w	a5,s2
    if(state == 0){
 70a:	fe0997e3          	bnez	s3,6f8 <vprintf+0x5c>
      if(c == '%'){
 70e:	fd479ee3          	bne	a5,s4,6ea <vprintf+0x4e>
        state = '%';
 712:	89be                	mv	s3,a5
 714:	b7e5                	j	6fc <vprintf+0x60>
      if(c == 'd'){
 716:	05878063          	beq	a5,s8,756 <vprintf+0xba>
      } else if(c == 'l') {
 71a:	05978c63          	beq	a5,s9,772 <vprintf+0xd6>
      } else if(c == 'x') {
 71e:	07a78863          	beq	a5,s10,78e <vprintf+0xf2>
      } else if(c == 'p') {
 722:	09b78463          	beq	a5,s11,7aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 726:	07300713          	li	a4,115
 72a:	0ce78663          	beq	a5,a4,7f6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72e:	06300713          	li	a4,99
 732:	0ee78e63          	beq	a5,a4,82e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 736:	11478863          	beq	a5,s4,846 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 73a:	85d2                	mv	a1,s4
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	e92080e7          	jalr	-366(ra) # 5d0 <putc>
        putc(fd, c);
 746:	85ca                	mv	a1,s2
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e86080e7          	jalr	-378(ra) # 5d0 <putc>
      }
      state = 0;
 752:	4981                	li	s3,0
 754:	b765                	j	6fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 756:	008b0913          	addi	s2,s6,8
 75a:	4685                	li	a3,1
 75c:	4629                	li	a2,10
 75e:	000b2583          	lw	a1,0(s6)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	e8e080e7          	jalr	-370(ra) # 5f2 <printint>
 76c:	8b4a                	mv	s6,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	b771                	j	6fc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	008b0913          	addi	s2,s6,8
 776:	4681                	li	a3,0
 778:	4629                	li	a2,10
 77a:	000b2583          	lw	a1,0(s6)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e72080e7          	jalr	-398(ra) # 5f2 <printint>
 788:	8b4a                	mv	s6,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bf85                	j	6fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 78e:	008b0913          	addi	s2,s6,8
 792:	4681                	li	a3,0
 794:	4641                	li	a2,16
 796:	000b2583          	lw	a1,0(s6)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e56080e7          	jalr	-426(ra) # 5f2 <printint>
 7a4:	8b4a                	mv	s6,s2
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	bf91                	j	6fc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7aa:	008b0793          	addi	a5,s6,8
 7ae:	f8f43423          	sd	a5,-120(s0)
 7b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7b6:	03000593          	li	a1,48
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e14080e7          	jalr	-492(ra) # 5d0 <putc>
  putc(fd, 'x');
 7c4:	85ea                	mv	a1,s10
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e08080e7          	jalr	-504(ra) # 5d0 <putc>
 7d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d2:	03c9d793          	srli	a5,s3,0x3c
 7d6:	97de                	add	a5,a5,s7
 7d8:	0007c583          	lbu	a1,0(a5)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	df2080e7          	jalr	-526(ra) # 5d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e6:	0992                	slli	s3,s3,0x4
 7e8:	397d                	addiw	s2,s2,-1
 7ea:	fe0914e3          	bnez	s2,7d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b721                	j	6fc <vprintf+0x60>
        s = va_arg(ap, char*);
 7f6:	008b0993          	addi	s3,s6,8
 7fa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7fe:	02090163          	beqz	s2,820 <vprintf+0x184>
        while(*s != 0){
 802:	00094583          	lbu	a1,0(s2)
 806:	c9a1                	beqz	a1,856 <vprintf+0x1ba>
          putc(fd, *s);
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	dc6080e7          	jalr	-570(ra) # 5d0 <putc>
          s++;
 812:	0905                	addi	s2,s2,1
        while(*s != 0){
 814:	00094583          	lbu	a1,0(s2)
 818:	f9e5                	bnez	a1,808 <vprintf+0x16c>
        s = va_arg(ap, char*);
 81a:	8b4e                	mv	s6,s3
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bdf9                	j	6fc <vprintf+0x60>
          s = "(null)";
 820:	00000917          	auipc	s2,0x0
 824:	2d890913          	addi	s2,s2,728 # af8 <malloc+0x192>
        while(*s != 0){
 828:	02800593          	li	a1,40
 82c:	bff1                	j	808 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 82e:	008b0913          	addi	s2,s6,8
 832:	000b4583          	lbu	a1,0(s6)
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	d98080e7          	jalr	-616(ra) # 5d0 <putc>
 840:	8b4a                	mv	s6,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bd65                	j	6fc <vprintf+0x60>
        putc(fd, c);
 846:	85d2                	mv	a1,s4
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	d86080e7          	jalr	-634(ra) # 5d0 <putc>
      state = 0;
 852:	4981                	li	s3,0
 854:	b565                	j	6fc <vprintf+0x60>
        s = va_arg(ap, char*);
 856:	8b4e                	mv	s6,s3
      state = 0;
 858:	4981                	li	s3,0
 85a:	b54d                	j	6fc <vprintf+0x60>
    }
  }
}
 85c:	70e6                	ld	ra,120(sp)
 85e:	7446                	ld	s0,112(sp)
 860:	74a6                	ld	s1,104(sp)
 862:	7906                	ld	s2,96(sp)
 864:	69e6                	ld	s3,88(sp)
 866:	6a46                	ld	s4,80(sp)
 868:	6aa6                	ld	s5,72(sp)
 86a:	6b06                	ld	s6,64(sp)
 86c:	7be2                	ld	s7,56(sp)
 86e:	7c42                	ld	s8,48(sp)
 870:	7ca2                	ld	s9,40(sp)
 872:	7d02                	ld	s10,32(sp)
 874:	6de2                	ld	s11,24(sp)
 876:	6109                	addi	sp,sp,128
 878:	8082                	ret

000000000000087a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 87a:	715d                	addi	sp,sp,-80
 87c:	ec06                	sd	ra,24(sp)
 87e:	e822                	sd	s0,16(sp)
 880:	1000                	addi	s0,sp,32
 882:	e010                	sd	a2,0(s0)
 884:	e414                	sd	a3,8(s0)
 886:	e818                	sd	a4,16(s0)
 888:	ec1c                	sd	a5,24(s0)
 88a:	03043023          	sd	a6,32(s0)
 88e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 896:	8622                	mv	a2,s0
 898:	00000097          	auipc	ra,0x0
 89c:	e04080e7          	jalr	-508(ra) # 69c <vprintf>
}
 8a0:	60e2                	ld	ra,24(sp)
 8a2:	6442                	ld	s0,16(sp)
 8a4:	6161                	addi	sp,sp,80
 8a6:	8082                	ret

00000000000008a8 <printf>:

void
printf(const char *fmt, ...)
{
 8a8:	711d                	addi	sp,sp,-96
 8aa:	ec06                	sd	ra,24(sp)
 8ac:	e822                	sd	s0,16(sp)
 8ae:	1000                	addi	s0,sp,32
 8b0:	e40c                	sd	a1,8(s0)
 8b2:	e810                	sd	a2,16(s0)
 8b4:	ec14                	sd	a3,24(s0)
 8b6:	f018                	sd	a4,32(s0)
 8b8:	f41c                	sd	a5,40(s0)
 8ba:	03043823          	sd	a6,48(s0)
 8be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c2:	00840613          	addi	a2,s0,8
 8c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ca:	85aa                	mv	a1,a0
 8cc:	4505                	li	a0,1
 8ce:	00000097          	auipc	ra,0x0
 8d2:	dce080e7          	jalr	-562(ra) # 69c <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6125                	addi	sp,sp,96
 8dc:	8082                	ret

00000000000008de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8de:	1141                	addi	sp,sp,-16
 8e0:	e422                	sd	s0,8(sp)
 8e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	00000797          	auipc	a5,0x0
 8ec:	7187b783          	ld	a5,1816(a5) # 1000 <freep>
 8f0:	a805                	j	920 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f2:	4618                	lw	a4,8(a2)
 8f4:	9db9                	addw	a1,a1,a4
 8f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	6318                	ld	a4,0(a4)
 8fe:	fee53823          	sd	a4,-16(a0)
 902:	a091                	j	946 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 904:	ff852703          	lw	a4,-8(a0)
 908:	9e39                	addw	a2,a2,a4
 90a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 90c:	ff053703          	ld	a4,-16(a0)
 910:	e398                	sd	a4,0(a5)
 912:	a099                	j	958 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	6398                	ld	a4,0(a5)
 916:	00e7e463          	bltu	a5,a4,91e <free+0x40>
 91a:	00e6ea63          	bltu	a3,a4,92e <free+0x50>
{
 91e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	fed7fae3          	bgeu	a5,a3,914 <free+0x36>
 924:	6398                	ld	a4,0(a5)
 926:	00e6e463          	bltu	a3,a4,92e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	fee7eae3          	bltu	a5,a4,91e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 92e:	ff852583          	lw	a1,-8(a0)
 932:	6390                	ld	a2,0(a5)
 934:	02059713          	slli	a4,a1,0x20
 938:	9301                	srli	a4,a4,0x20
 93a:	0712                	slli	a4,a4,0x4
 93c:	9736                	add	a4,a4,a3
 93e:	fae60ae3          	beq	a2,a4,8f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 942:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 946:	4790                	lw	a2,8(a5)
 948:	02061713          	slli	a4,a2,0x20
 94c:	9301                	srli	a4,a4,0x20
 94e:	0712                	slli	a4,a4,0x4
 950:	973e                	add	a4,a4,a5
 952:	fae689e3          	beq	a3,a4,904 <free+0x26>
  } else
    p->s.ptr = bp;
 956:	e394                	sd	a3,0(a5)
  freep = p;
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
}
 960:	6422                	ld	s0,8(sp)
 962:	0141                	addi	sp,sp,16
 964:	8082                	ret

0000000000000966 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 966:	7139                	addi	sp,sp,-64
 968:	fc06                	sd	ra,56(sp)
 96a:	f822                	sd	s0,48(sp)
 96c:	f426                	sd	s1,40(sp)
 96e:	f04a                	sd	s2,32(sp)
 970:	ec4e                	sd	s3,24(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
 978:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97a:	02051493          	slli	s1,a0,0x20
 97e:	9081                	srli	s1,s1,0x20
 980:	04bd                	addi	s1,s1,15
 982:	8091                	srli	s1,s1,0x4
 984:	0014899b          	addiw	s3,s1,1
 988:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 98a:	00000517          	auipc	a0,0x0
 98e:	67653503          	ld	a0,1654(a0) # 1000 <freep>
 992:	c515                	beqz	a0,9be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 994:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 996:	4798                	lw	a4,8(a5)
 998:	02977f63          	bgeu	a4,s1,9d6 <malloc+0x70>
 99c:	8a4e                	mv	s4,s3
 99e:	0009871b          	sext.w	a4,s3
 9a2:	6685                	lui	a3,0x1
 9a4:	00d77363          	bgeu	a4,a3,9aa <malloc+0x44>
 9a8:	6a05                	lui	s4,0x1
 9aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b2:	00000917          	auipc	s2,0x0
 9b6:	64e90913          	addi	s2,s2,1614 # 1000 <freep>
  if(p == (char*)-1)
 9ba:	5afd                	li	s5,-1
 9bc:	a88d                	j	a2e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9be:	00000797          	auipc	a5,0x0
 9c2:	65278793          	addi	a5,a5,1618 # 1010 <base>
 9c6:	00000717          	auipc	a4,0x0
 9ca:	62f73d23          	sd	a5,1594(a4) # 1000 <freep>
 9ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d4:	b7e1                	j	99c <malloc+0x36>
      if(p->s.size == nunits)
 9d6:	02e48b63          	beq	s1,a4,a0c <malloc+0xa6>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	1702                	slli	a4,a4,0x20
 9e2:	9301                	srli	a4,a4,0x20
 9e4:	0712                	slli	a4,a4,0x4
 9e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60a73a23          	sd	a0,1556(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	7902                	ld	s2,32(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
 a08:	6121                	addi	sp,sp,64
 a0a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a0c:	6398                	ld	a4,0(a5)
 a0e:	e118                	sd	a4,0(a0)
 a10:	bff1                	j	9ec <malloc+0x86>
  hp->s.size = nu;
 a12:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a16:	0541                	addi	a0,a0,16
 a18:	00000097          	auipc	ra,0x0
 a1c:	ec6080e7          	jalr	-314(ra) # 8de <free>
  return freep;
 a20:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a24:	d971                	beqz	a0,9f8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	fa9776e3          	bgeu	a4,s1,9d6 <malloc+0x70>
    if(p == freep)
 a2e:	00093703          	ld	a4,0(s2)
 a32:	853e                	mv	a0,a5
 a34:	fef719e3          	bne	a4,a5,a26 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a38:	8552                	mv	a0,s4
 a3a:	00000097          	auipc	ra,0x0
 a3e:	b7e080e7          	jalr	-1154(ra) # 5b8 <sbrk>
  if(p == (char*)-1)
 a42:	fd5518e3          	bne	a0,s5,a12 <malloc+0xac>
        return 0;
 a46:	4501                	li	a0,0
 a48:	bf45                	j	9f8 <malloc+0x92>
