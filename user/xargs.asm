
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define is_blank(chr) (chr == ' ' || chr == '\t') 

int
main(int argc, char *argv[])
{
   0:	7109                	addi	sp,sp,-384
   2:	fe86                	sd	ra,376(sp)
   4:	faa2                	sd	s0,368(sp)
   6:	f6a6                	sd	s1,360(sp)
   8:	f2ca                	sd	s2,352(sp)
   a:	eece                	sd	s3,344(sp)
   c:	ead2                	sd	s4,336(sp)
   e:	e6d6                	sd	s5,328(sp)
  10:	e2da                	sd	s6,320(sp)
  12:	fe5e                	sd	s7,312(sp)
  14:	fa62                	sd	s8,304(sp)
  16:	f666                	sd	s9,296(sp)
  18:	f26a                	sd	s10,288(sp)
  1a:	0300                	addi	s0,sp,384
  1c:	81010113          	addi	sp,sp,-2032
	char *v[MAXARG];
	int c;
	int blanks = 0;
	int offset = 0;

	if(argc <= 1){
  20:	4785                	li	a5,1
  22:	06a7d063          	bge	a5,a0,82 <main+0x82>
  26:	00858713          	addi	a4,a1,8
  2a:	77fd                	lui	a5,0xfffff
  2c:	6f878793          	addi	a5,a5,1784 # fffffffffffff6f8 <base+0xffffffffffffe6e8>
  30:	fa040693          	addi	a3,s0,-96
  34:	97b6                	add	a5,a5,a3
  36:	0005099b          	sext.w	s3,a0
  3a:	ffe5061b          	addiw	a2,a0,-2
  3e:	1602                	slli	a2,a2,0x20
  40:	9201                	srli	a2,a2,0x20
  42:	060e                	slli	a2,a2,0x3
  44:	00878693          	addi	a3,a5,8
  48:	9636                	add	a2,a2,a3
		fprintf(2, "usage: xargs <command> [argv...]\n");
		exit(1);
	}

	for (c = 1; c < argc; c++) {
		v[c-1] = argv[c];
  4a:	6314                	ld	a3,0(a4)
  4c:	e394                	sd	a3,0(a5)
	for (c = 1; c < argc; c++) {
  4e:	0721                	addi	a4,a4,8
  50:	07a1                	addi	a5,a5,8
  52:	fec79ce3          	bne	a5,a2,4a <main+0x4a>
  56:	39fd                	addiw	s3,s3,-1
	int offset = 0;
  58:	4481                	li	s1,0
	int blanks = 0;
  5a:	4901                	li	s2,0
	char *p = buf;
  5c:	77fd                	lui	a5,0xfffff
  5e:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <base+0xffffffffffffe790>
  62:	00f40bb3          	add	s7,s0,a5
	}
	--c;

	while (read(0, &ch, 1) > 0) {
  66:	7a7d                	lui	s4,0xfffff
  68:	7ffa0a93          	addi	s5,s4,2047 # fffffffffffff7ff <base+0xffffffffffffe7ef>
  6c:	fa040793          	addi	a5,s0,-96
  70:	9abe                	add	s5,s5,a5
		if (is_blank(ch)) {
  72:	9a3e                	add	s4,s4,a5
  74:	02000b13          	li	s6,32
  78:	4c25                	li	s8,9
			p = buf + offset;

			blanks = 0;
		}

		if (ch != '\n') {
  7a:	4d29                	li	s10,10
			if (!fork()) {
				exit(exec(v[0], v));
			}
			wait(0);
			
			c = argc - 1;
  7c:	fff50c9b          	addiw	s9,a0,-1
	while (read(0, &ch, 1) > 0) {
  80:	a815                	j	b4 <main+0xb4>
		fprintf(2, "usage: xargs <command> [argv...]\n");
  82:	00001597          	auipc	a1,0x1
  86:	88e58593          	addi	a1,a1,-1906 # 910 <malloc+0xf0>
  8a:	4509                	li	a0,2
  8c:	00000097          	auipc	ra,0x0
  90:	6a8080e7          	jalr	1704(ra) # 734 <fprintf>
		exit(1);
  94:	4505                	li	a0,1
  96:	00000097          	auipc	ra,0x0
  9a:	354080e7          	jalr	852(ra) # 3ea <exit>
			blanks++;
  9e:	2905                	addiw	s2,s2,1
			continue;
  a0:	a811                	j	b4 <main+0xb4>
		if (ch != '\n') {
  a2:	05a78f63          	beq	a5,s10,100 <main+0x100>
			buf[offset++] = ch;
  a6:	fa040713          	addi	a4,s0,-96
  aa:	9726                	add	a4,a4,s1
  ac:	80f70023          	sb	a5,-2048(a4)
  b0:	2485                	addiw	s1,s1,1
  b2:	4901                	li	s2,0
	while (read(0, &ch, 1) > 0) {
  b4:	4605                	li	a2,1
  b6:	85d6                	mv	a1,s5
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	348080e7          	jalr	840(ra) # 402 <read>
  c2:	08a05763          	blez	a0,150 <main+0x150>
		if (is_blank(ch)) {
  c6:	7ffa4783          	lbu	a5,2047(s4)
  ca:	fd678ae3          	beq	a5,s6,9e <main+0x9e>
  ce:	fd8788e3          	beq	a5,s8,9e <main+0x9e>
		if (blanks) {  
  d2:	fc0908e3          	beqz	s2,a2 <main+0xa2>
			buf[offset++] = 0;
  d6:	0014869b          	addiw	a3,s1,1
  da:	fa040713          	addi	a4,s0,-96
  de:	94ba                	add	s1,s1,a4
  e0:	80048023          	sb	zero,-2048(s1)
			v[c++] = p;
  e4:	00399713          	slli	a4,s3,0x3
  e8:	9752                	add	a4,a4,s4
  ea:	6f773c23          	sd	s7,1784(a4)
			p = buf + offset;
  ee:	777d                	lui	a4,0xfffff
  f0:	7a070713          	addi	a4,a4,1952 # fffffffffffff7a0 <base+0xffffffffffffe790>
  f4:	9722                	add	a4,a4,s0
  f6:	00d70bb3          	add	s7,a4,a3
			buf[offset++] = 0;
  fa:	84b6                	mv	s1,a3
			v[c++] = p;
  fc:	2985                	addiw	s3,s3,1
  fe:	b755                	j	a2 <main+0xa2>
			v[c++] = p;
 100:	098e                	slli	s3,s3,0x3
 102:	99d2                	add	s3,s3,s4
 104:	6f79bc23          	sd	s7,1784(s3)
			p = buf + offset;
 108:	77fd                	lui	a5,0xfffff
 10a:	7a078793          	addi	a5,a5,1952 # fffffffffffff7a0 <base+0xffffffffffffe790>
 10e:	97a2                	add	a5,a5,s0
 110:	00978bb3          	add	s7,a5,s1
			if (!fork()) {
 114:	00000097          	auipc	ra,0x0
 118:	2ce080e7          	jalr	718(ra) # 3e2 <fork>
 11c:	c909                	beqz	a0,12e <main+0x12e>
			wait(0);
 11e:	4501                	li	a0,0
 120:	00000097          	auipc	ra,0x0
 124:	2d2080e7          	jalr	722(ra) # 3f2 <wait>
			c = argc - 1;
 128:	89e6                	mv	s3,s9
 12a:	4901                	li	s2,0
 12c:	b761                	j	b4 <main+0xb4>
				exit(exec(v[0], v));
 12e:	77fd                	lui	a5,0xfffff
 130:	6f878593          	addi	a1,a5,1784 # fffffffffffff6f8 <base+0xffffffffffffe6e8>
 134:	fa040713          	addi	a4,s0,-96
 138:	97ba                	add	a5,a5,a4
 13a:	95ba                	add	a1,a1,a4
 13c:	6f87b503          	ld	a0,1784(a5)
 140:	00000097          	auipc	ra,0x0
 144:	2e2080e7          	jalr	738(ra) # 422 <exec>
 148:	00000097          	auipc	ra,0x0
 14c:	2a2080e7          	jalr	674(ra) # 3ea <exit>
		}
	}

	exit(0);
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	298080e7          	jalr	664(ra) # 3ea <exit>

000000000000015a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
  extern int main();
  main();
 162:	00000097          	auipc	ra,0x0
 166:	e9e080e7          	jalr	-354(ra) # 0 <main>
  exit(0);
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	27e080e7          	jalr	638(ra) # 3ea <exit>

0000000000000174 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17a:	87aa                	mv	a5,a0
 17c:	0585                	addi	a1,a1,1
 17e:	0785                	addi	a5,a5,1
 180:	fff5c703          	lbu	a4,-1(a1)
 184:	fee78fa3          	sb	a4,-1(a5)
 188:	fb75                	bnez	a4,17c <strcpy+0x8>
    ;
  return os;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x1e>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x1e>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cf91                	beqz	a5,1e2 <strlen+0x26>
 1c8:	0505                	addi	a0,a0,1
 1ca:	87aa                	mv	a5,a0
 1cc:	4685                	li	a3,1
 1ce:	9e89                	subw	a3,a3,a0
 1d0:	00f6853b          	addw	a0,a3,a5
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff7c703          	lbu	a4,-1(a5)
 1da:	fb7d                	bnez	a4,1d0 <strlen+0x14>
    ;
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  for(n = 0; s[n]; n++)
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <strlen+0x20>

00000000000001e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ec:	ce09                	beqz	a2,206 <memset+0x20>
 1ee:	87aa                	mv	a5,a0
 1f0:	fff6071b          	addiw	a4,a2,-1
 1f4:	1702                	slli	a4,a4,0x20
 1f6:	9301                	srli	a4,a4,0x20
 1f8:	0705                	addi	a4,a4,1
 1fa:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 200:	0785                	addi	a5,a5,1
 202:	fee79de3          	bne	a5,a4,1fc <memset+0x16>
  }
  return dst;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strchr>:

char*
strchr(const char *s, char c)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  for(; *s; s++)
 212:	00054783          	lbu	a5,0(a0)
 216:	cb99                	beqz	a5,22c <strchr+0x20>
    if(*s == c)
 218:	00f58763          	beq	a1,a5,226 <strchr+0x1a>
  for(; *s; s++)
 21c:	0505                	addi	a0,a0,1
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbfd                	bnez	a5,218 <strchr+0xc>
      return (char*)s;
  return 0;
 224:	4501                	li	a0,0
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  return 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <strchr+0x1a>

0000000000000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	711d                	addi	sp,sp,-96
 232:	ec86                	sd	ra,88(sp)
 234:	e8a2                	sd	s0,80(sp)
 236:	e4a6                	sd	s1,72(sp)
 238:	e0ca                	sd	s2,64(sp)
 23a:	fc4e                	sd	s3,56(sp)
 23c:	f852                	sd	s4,48(sp)
 23e:	f456                	sd	s5,40(sp)
 240:	f05a                	sd	s6,32(sp)
 242:	ec5e                	sd	s7,24(sp)
 244:	1080                	addi	s0,sp,96
 246:	8baa                	mv	s7,a0
 248:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	892a                	mv	s2,a0
 24c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24e:	4aa9                	li	s5,10
 250:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 252:	89a6                	mv	s3,s1
 254:	2485                	addiw	s1,s1,1
 256:	0344d863          	bge	s1,s4,286 <gets+0x56>
    cc = read(0, &c, 1);
 25a:	4605                	li	a2,1
 25c:	faf40593          	addi	a1,s0,-81
 260:	4501                	li	a0,0
 262:	00000097          	auipc	ra,0x0
 266:	1a0080e7          	jalr	416(ra) # 402 <read>
    if(cc < 1)
 26a:	00a05e63          	blez	a0,286 <gets+0x56>
    buf[i++] = c;
 26e:	faf44783          	lbu	a5,-81(s0)
 272:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 276:	01578763          	beq	a5,s5,284 <gets+0x54>
 27a:	0905                	addi	s2,s2,1
 27c:	fd679be3          	bne	a5,s6,252 <gets+0x22>
  for(i=0; i+1 < max; ){
 280:	89a6                	mv	s3,s1
 282:	a011                	j	286 <gets+0x56>
 284:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 286:	99de                	add	s3,s3,s7
 288:	00098023          	sb	zero,0(s3)
  return buf;
}
 28c:	855e                	mv	a0,s7
 28e:	60e6                	ld	ra,88(sp)
 290:	6446                	ld	s0,80(sp)
 292:	64a6                	ld	s1,72(sp)
 294:	6906                	ld	s2,64(sp)
 296:	79e2                	ld	s3,56(sp)
 298:	7a42                	ld	s4,48(sp)
 29a:	7aa2                	ld	s5,40(sp)
 29c:	7b02                	ld	s6,32(sp)
 29e:	6be2                	ld	s7,24(sp)
 2a0:	6125                	addi	sp,sp,96
 2a2:	8082                	ret

00000000000002a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a4:	1101                	addi	sp,sp,-32
 2a6:	ec06                	sd	ra,24(sp)
 2a8:	e822                	sd	s0,16(sp)
 2aa:	e426                	sd	s1,8(sp)
 2ac:	e04a                	sd	s2,0(sp)
 2ae:	1000                	addi	s0,sp,32
 2b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b2:	4581                	li	a1,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	176080e7          	jalr	374(ra) # 42a <open>
  if(fd < 0)
 2bc:	02054563          	bltz	a0,2e6 <stat+0x42>
 2c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c2:	85ca                	mv	a1,s2
 2c4:	00000097          	auipc	ra,0x0
 2c8:	17e080e7          	jalr	382(ra) # 442 <fstat>
 2cc:	892a                	mv	s2,a0
  close(fd);
 2ce:	8526                	mv	a0,s1
 2d0:	00000097          	auipc	ra,0x0
 2d4:	142080e7          	jalr	322(ra) # 412 <close>
  return r;
}
 2d8:	854a                	mv	a0,s2
 2da:	60e2                	ld	ra,24(sp)
 2dc:	6442                	ld	s0,16(sp)
 2de:	64a2                	ld	s1,8(sp)
 2e0:	6902                	ld	s2,0(sp)
 2e2:	6105                	addi	sp,sp,32
 2e4:	8082                	ret
    return -1;
 2e6:	597d                	li	s2,-1
 2e8:	bfc5                	j	2d8 <stat+0x34>

00000000000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f0:	00054603          	lbu	a2,0(a0)
 2f4:	fd06079b          	addiw	a5,a2,-48
 2f8:	0ff7f793          	andi	a5,a5,255
 2fc:	4725                	li	a4,9
 2fe:	02f76963          	bltu	a4,a5,330 <atoi+0x46>
 302:	86aa                	mv	a3,a0
  n = 0;
 304:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 306:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 308:	0685                	addi	a3,a3,1
 30a:	0025179b          	slliw	a5,a0,0x2
 30e:	9fa9                	addw	a5,a5,a0
 310:	0017979b          	slliw	a5,a5,0x1
 314:	9fb1                	addw	a5,a5,a2
 316:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31a:	0006c603          	lbu	a2,0(a3)
 31e:	fd06071b          	addiw	a4,a2,-48
 322:	0ff77713          	andi	a4,a4,255
 326:	fee5f1e3          	bgeu	a1,a4,308 <atoi+0x1e>
  return n;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  n = 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <atoi+0x40>

0000000000000334 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33a:	02b57663          	bgeu	a0,a1,366 <memmove+0x32>
    while(n-- > 0)
 33e:	02c05163          	blez	a2,360 <memmove+0x2c>
 342:	fff6079b          	addiw	a5,a2,-1
 346:	1782                	slli	a5,a5,0x20
 348:	9381                	srli	a5,a5,0x20
 34a:	0785                	addi	a5,a5,1
 34c:	97aa                	add	a5,a5,a0
  dst = vdst;
 34e:	872a                	mv	a4,a0
      *dst++ = *src++;
 350:	0585                	addi	a1,a1,1
 352:	0705                	addi	a4,a4,1
 354:	fff5c683          	lbu	a3,-1(a1)
 358:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35c:	fee79ae3          	bne	a5,a4,350 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
    dst += n;
 366:	00c50733          	add	a4,a0,a2
    src += n;
 36a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 36c:	fec05ae3          	blez	a2,360 <memmove+0x2c>
 370:	fff6079b          	addiw	a5,a2,-1
 374:	1782                	slli	a5,a5,0x20
 376:	9381                	srli	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37e:	15fd                	addi	a1,a1,-1
 380:	177d                	addi	a4,a4,-1
 382:	0005c683          	lbu	a3,0(a1)
 386:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38a:	fee79ae3          	bne	a5,a4,37e <memmove+0x4a>
 38e:	bfc9                	j	360 <memmove+0x2c>

0000000000000390 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 396:	ca05                	beqz	a2,3c6 <memcmp+0x36>
 398:	fff6069b          	addiw	a3,a2,-1
 39c:	1682                	slli	a3,a3,0x20
 39e:	9281                	srli	a3,a3,0x20
 3a0:	0685                	addi	a3,a3,1
 3a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	0005c703          	lbu	a4,0(a1)
 3ac:	00e79863          	bne	a5,a4,3bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b0:	0505                	addi	a0,a0,1
    p2++;
 3b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b4:	fed518e3          	bne	a0,a3,3a4 <memcmp+0x14>
  }
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	a019                	j	3c0 <memcmp+0x30>
      return *p1 - *p2;
 3bc:	40e7853b          	subw	a0,a5,a4
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <memcmp+0x30>

00000000000003ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e406                	sd	ra,8(sp)
 3ce:	e022                	sd	s0,0(sp)
 3d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f62080e7          	jalr	-158(ra) # 334 <memmove>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e2:	4885                	li	a7,1
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ea:	4889                	li	a7,2
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f2:	488d                	li	a7,3
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fa:	4891                	li	a7,4
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <read>:
.global read
read:
 li a7, SYS_read
 402:	4895                	li	a7,5
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <write>:
.global write
write:
 li a7, SYS_write
 40a:	48c1                	li	a7,16
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <close>:
.global close
close:
 li a7, SYS_close
 412:	48d5                	li	a7,21
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <kill>:
.global kill
kill:
 li a7, SYS_kill
 41a:	4899                	li	a7,6
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exec>:
.global exec
exec:
 li a7, SYS_exec
 422:	489d                	li	a7,7
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	48bd                	li	a7,15
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 432:	48c5                	li	a7,17
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43a:	48c9                	li	a7,18
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 442:	48a1                	li	a7,8
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <link>:
.global link
link:
 li a7, SYS_link
 44a:	48cd                	li	a7,19
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 452:	48d1                	li	a7,20
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45a:	48a5                	li	a7,9
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <dup>:
.global dup
dup:
 li a7, SYS_dup
 462:	48a9                	li	a7,10
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46a:	48ad                	li	a7,11
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 472:	48b1                	li	a7,12
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47a:	48b5                	li	a7,13
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 482:	48b9                	li	a7,14
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48a:	1101                	addi	sp,sp,-32
 48c:	ec06                	sd	ra,24(sp)
 48e:	e822                	sd	s0,16(sp)
 490:	1000                	addi	s0,sp,32
 492:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 496:	4605                	li	a2,1
 498:	fef40593          	addi	a1,s0,-17
 49c:	00000097          	auipc	ra,0x0
 4a0:	f6e080e7          	jalr	-146(ra) # 40a <write>
}
 4a4:	60e2                	ld	ra,24(sp)
 4a6:	6442                	ld	s0,16(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret

00000000000004ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ac:	7139                	addi	sp,sp,-64
 4ae:	fc06                	sd	ra,56(sp)
 4b0:	f822                	sd	s0,48(sp)
 4b2:	f426                	sd	s1,40(sp)
 4b4:	f04a                	sd	s2,32(sp)
 4b6:	ec4e                	sd	s3,24(sp)
 4b8:	0080                	addi	s0,sp,64
 4ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4bc:	c299                	beqz	a3,4c2 <printint+0x16>
 4be:	0805c863          	bltz	a1,54e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c2:	2581                	sext.w	a1,a1
  neg = 0;
 4c4:	4881                	li	a7,0
 4c6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4cc:	2601                	sext.w	a2,a2
 4ce:	00000517          	auipc	a0,0x0
 4d2:	47250513          	addi	a0,a0,1138 # 940 <digits>
 4d6:	883a                	mv	a6,a4
 4d8:	2705                	addiw	a4,a4,1
 4da:	02c5f7bb          	remuw	a5,a1,a2
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	97aa                	add	a5,a5,a0
 4e4:	0007c783          	lbu	a5,0(a5)
 4e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ec:	0005879b          	sext.w	a5,a1
 4f0:	02c5d5bb          	divuw	a1,a1,a2
 4f4:	0685                	addi	a3,a3,1
 4f6:	fec7f0e3          	bgeu	a5,a2,4d6 <printint+0x2a>
  if(neg)
 4fa:	00088b63          	beqz	a7,510 <printint+0x64>
    buf[i++] = '-';
 4fe:	fd040793          	addi	a5,s0,-48
 502:	973e                	add	a4,a4,a5
 504:	02d00793          	li	a5,45
 508:	fef70823          	sb	a5,-16(a4)
 50c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 510:	02e05863          	blez	a4,540 <printint+0x94>
 514:	fc040793          	addi	a5,s0,-64
 518:	00e78933          	add	s2,a5,a4
 51c:	fff78993          	addi	s3,a5,-1
 520:	99ba                	add	s3,s3,a4
 522:	377d                	addiw	a4,a4,-1
 524:	1702                	slli	a4,a4,0x20
 526:	9301                	srli	a4,a4,0x20
 528:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52c:	fff94583          	lbu	a1,-1(s2)
 530:	8526                	mv	a0,s1
 532:	00000097          	auipc	ra,0x0
 536:	f58080e7          	jalr	-168(ra) # 48a <putc>
  while(--i >= 0)
 53a:	197d                	addi	s2,s2,-1
 53c:	ff3918e3          	bne	s2,s3,52c <printint+0x80>
}
 540:	70e2                	ld	ra,56(sp)
 542:	7442                	ld	s0,48(sp)
 544:	74a2                	ld	s1,40(sp)
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
 54a:	6121                	addi	sp,sp,64
 54c:	8082                	ret
    x = -xx;
 54e:	40b005bb          	negw	a1,a1
    neg = 1;
 552:	4885                	li	a7,1
    x = -xx;
 554:	bf8d                	j	4c6 <printint+0x1a>

0000000000000556 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 556:	7119                	addi	sp,sp,-128
 558:	fc86                	sd	ra,120(sp)
 55a:	f8a2                	sd	s0,112(sp)
 55c:	f4a6                	sd	s1,104(sp)
 55e:	f0ca                	sd	s2,96(sp)
 560:	ecce                	sd	s3,88(sp)
 562:	e8d2                	sd	s4,80(sp)
 564:	e4d6                	sd	s5,72(sp)
 566:	e0da                	sd	s6,64(sp)
 568:	fc5e                	sd	s7,56(sp)
 56a:	f862                	sd	s8,48(sp)
 56c:	f466                	sd	s9,40(sp)
 56e:	f06a                	sd	s10,32(sp)
 570:	ec6e                	sd	s11,24(sp)
 572:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 574:	0005c903          	lbu	s2,0(a1)
 578:	18090f63          	beqz	s2,716 <vprintf+0x1c0>
 57c:	8aaa                	mv	s5,a0
 57e:	8b32                	mv	s6,a2
 580:	00158493          	addi	s1,a1,1
  state = 0;
 584:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 586:	02500a13          	li	s4,37
      if(c == 'd'){
 58a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 58e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 592:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 596:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59a:	00000b97          	auipc	s7,0x0
 59e:	3a6b8b93          	addi	s7,s7,934 # 940 <digits>
 5a2:	a839                	j	5c0 <vprintf+0x6a>
        putc(fd, c);
 5a4:	85ca                	mv	a1,s2
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	ee2080e7          	jalr	-286(ra) # 48a <putc>
 5b0:	a019                	j	5b6 <vprintf+0x60>
    } else if(state == '%'){
 5b2:	01498f63          	beq	s3,s4,5d0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b6:	0485                	addi	s1,s1,1
 5b8:	fff4c903          	lbu	s2,-1(s1)
 5bc:	14090d63          	beqz	s2,716 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c4:	fe0997e3          	bnez	s3,5b2 <vprintf+0x5c>
      if(c == '%'){
 5c8:	fd479ee3          	bne	a5,s4,5a4 <vprintf+0x4e>
        state = '%';
 5cc:	89be                	mv	s3,a5
 5ce:	b7e5                	j	5b6 <vprintf+0x60>
      if(c == 'd'){
 5d0:	05878063          	beq	a5,s8,610 <vprintf+0xba>
      } else if(c == 'l') {
 5d4:	05978c63          	beq	a5,s9,62c <vprintf+0xd6>
      } else if(c == 'x') {
 5d8:	07a78863          	beq	a5,s10,648 <vprintf+0xf2>
      } else if(c == 'p') {
 5dc:	09b78463          	beq	a5,s11,664 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e0:	07300713          	li	a4,115
 5e4:	0ce78663          	beq	a5,a4,6b0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e8:	06300713          	li	a4,99
 5ec:	0ee78e63          	beq	a5,a4,6e8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f0:	11478863          	beq	a5,s4,700 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f4:	85d2                	mv	a1,s4
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e92080e7          	jalr	-366(ra) # 48a <putc>
        putc(fd, c);
 600:	85ca                	mv	a1,s2
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e86080e7          	jalr	-378(ra) # 48a <putc>
      }
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b765                	j	5b6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b0913          	addi	s2,s6,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000b2583          	lw	a1,0(s6)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e8e080e7          	jalr	-370(ra) # 4ac <printint>
 626:	8b4a                	mv	s6,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	b771                	j	5b6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b0913          	addi	s2,s6,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000b2583          	lw	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e72080e7          	jalr	-398(ra) # 4ac <printint>
 642:	8b4a                	mv	s6,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	bf85                	j	5b6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 648:	008b0913          	addi	s2,s6,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000b2583          	lw	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e56080e7          	jalr	-426(ra) # 4ac <printint>
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bf91                	j	5b6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 664:	008b0793          	addi	a5,s6,8
 668:	f8f43423          	sd	a5,-120(s0)
 66c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 670:	03000593          	li	a1,48
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e14080e7          	jalr	-492(ra) # 48a <putc>
  putc(fd, 'x');
 67e:	85ea                	mv	a1,s10
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e08080e7          	jalr	-504(ra) # 48a <putc>
 68a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	03c9d793          	srli	a5,s3,0x3c
 690:	97de                	add	a5,a5,s7
 692:	0007c583          	lbu	a1,0(a5)
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	df2080e7          	jalr	-526(ra) # 48a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a0:	0992                	slli	s3,s3,0x4
 6a2:	397d                	addiw	s2,s2,-1
 6a4:	fe0914e3          	bnez	s2,68c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b721                	j	5b6 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b0:	008b0993          	addi	s3,s6,8
 6b4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b8:	02090163          	beqz	s2,6da <vprintf+0x184>
        while(*s != 0){
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	c9a1                	beqz	a1,710 <vprintf+0x1ba>
          putc(fd, *s);
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dc6080e7          	jalr	-570(ra) # 48a <putc>
          s++;
 6cc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ce:	00094583          	lbu	a1,0(s2)
 6d2:	f9e5                	bnez	a1,6c2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d4:	8b4e                	mv	s6,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bdf9                	j	5b6 <vprintf+0x60>
          s = "(null)";
 6da:	00000917          	auipc	s2,0x0
 6de:	25e90913          	addi	s2,s2,606 # 938 <malloc+0x118>
        while(*s != 0){
 6e2:	02800593          	li	a1,40
 6e6:	bff1                	j	6c2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e8:	008b0913          	addi	s2,s6,8
 6ec:	000b4583          	lbu	a1,0(s6)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	d98080e7          	jalr	-616(ra) # 48a <putc>
 6fa:	8b4a                	mv	s6,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd65                	j	5b6 <vprintf+0x60>
        putc(fd, c);
 700:	85d2                	mv	a1,s4
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	d86080e7          	jalr	-634(ra) # 48a <putc>
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b565                	j	5b6 <vprintf+0x60>
        s = va_arg(ap, char*);
 710:	8b4e                	mv	s6,s3
      state = 0;
 712:	4981                	li	s3,0
 714:	b54d                	j	5b6 <vprintf+0x60>
    }
  }
}
 716:	70e6                	ld	ra,120(sp)
 718:	7446                	ld	s0,112(sp)
 71a:	74a6                	ld	s1,104(sp)
 71c:	7906                	ld	s2,96(sp)
 71e:	69e6                	ld	s3,88(sp)
 720:	6a46                	ld	s4,80(sp)
 722:	6aa6                	ld	s5,72(sp)
 724:	6b06                	ld	s6,64(sp)
 726:	7be2                	ld	s7,56(sp)
 728:	7c42                	ld	s8,48(sp)
 72a:	7ca2                	ld	s9,40(sp)
 72c:	7d02                	ld	s10,32(sp)
 72e:	6de2                	ld	s11,24(sp)
 730:	6109                	addi	sp,sp,128
 732:	8082                	ret

0000000000000734 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 734:	715d                	addi	sp,sp,-80
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	e010                	sd	a2,0(s0)
 73e:	e414                	sd	a3,8(s0)
 740:	e818                	sd	a4,16(s0)
 742:	ec1c                	sd	a5,24(s0)
 744:	03043023          	sd	a6,32(s0)
 748:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 750:	8622                	mv	a2,s0
 752:	00000097          	auipc	ra,0x0
 756:	e04080e7          	jalr	-508(ra) # 556 <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6161                	addi	sp,sp,80
 760:	8082                	ret

0000000000000762 <printf>:

void
printf(const char *fmt, ...)
{
 762:	711d                	addi	sp,sp,-96
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e40c                	sd	a1,8(s0)
 76c:	e810                	sd	a2,16(s0)
 76e:	ec14                	sd	a3,24(s0)
 770:	f018                	sd	a4,32(s0)
 772:	f41c                	sd	a5,40(s0)
 774:	03043823          	sd	a6,48(s0)
 778:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	00840613          	addi	a2,s0,8
 780:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 784:	85aa                	mv	a1,a0
 786:	4505                	li	a0,1
 788:	00000097          	auipc	ra,0x0
 78c:	dce080e7          	jalr	-562(ra) # 556 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6125                	addi	sp,sp,96
 796:	8082                	ret

0000000000000798 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 798:	1141                	addi	sp,sp,-16
 79a:	e422                	sd	s0,8(sp)
 79c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	00001797          	auipc	a5,0x1
 7a6:	85e7b783          	ld	a5,-1954(a5) # 1000 <freep>
 7aa:	a805                	j	7da <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ac:	4618                	lw	a4,8(a2)
 7ae:	9db9                	addw	a1,a1,a4
 7b0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	6318                	ld	a4,0(a4)
 7b8:	fee53823          	sd	a4,-16(a0)
 7bc:	a091                	j	800 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7be:	ff852703          	lw	a4,-8(a0)
 7c2:	9e39                	addw	a2,a2,a4
 7c4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c6:	ff053703          	ld	a4,-16(a0)
 7ca:	e398                	sd	a4,0(a5)
 7cc:	a099                	j	812 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e7e463          	bltu	a5,a4,7d8 <free+0x40>
 7d4:	00e6ea63          	bltu	a3,a4,7e8 <free+0x50>
{
 7d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	fed7fae3          	bgeu	a5,a3,7ce <free+0x36>
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e6e463          	bltu	a3,a4,7e8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	fee7eae3          	bltu	a5,a4,7d8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e8:	ff852583          	lw	a1,-8(a0)
 7ec:	6390                	ld	a2,0(a5)
 7ee:	02059713          	slli	a4,a1,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	0712                	slli	a4,a4,0x4
 7f6:	9736                	add	a4,a4,a3
 7f8:	fae60ae3          	beq	a2,a4,7ac <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 800:	4790                	lw	a2,8(a5)
 802:	02061713          	slli	a4,a2,0x20
 806:	9301                	srli	a4,a4,0x20
 808:	0712                	slli	a4,a4,0x4
 80a:	973e                	add	a4,a4,a5
 80c:	fae689e3          	beq	a3,a4,7be <free+0x26>
  } else
    p->s.ptr = bp;
 810:	e394                	sd	a3,0(a5)
  freep = p;
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
}
 81a:	6422                	ld	s0,8(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret

0000000000000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	7139                	addi	sp,sp,-64
 822:	fc06                	sd	ra,56(sp)
 824:	f822                	sd	s0,48(sp)
 826:	f426                	sd	s1,40(sp)
 828:	f04a                	sd	s2,32(sp)
 82a:	ec4e                	sd	s3,24(sp)
 82c:	e852                	sd	s4,16(sp)
 82e:	e456                	sd	s5,8(sp)
 830:	e05a                	sd	s6,0(sp)
 832:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 834:	02051493          	slli	s1,a0,0x20
 838:	9081                	srli	s1,s1,0x20
 83a:	04bd                	addi	s1,s1,15
 83c:	8091                	srli	s1,s1,0x4
 83e:	0014899b          	addiw	s3,s1,1
 842:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 844:	00000517          	auipc	a0,0x0
 848:	7bc53503          	ld	a0,1980(a0) # 1000 <freep>
 84c:	c515                	beqz	a0,878 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 850:	4798                	lw	a4,8(a5)
 852:	02977f63          	bgeu	a4,s1,890 <malloc+0x70>
 856:	8a4e                	mv	s4,s3
 858:	0009871b          	sext.w	a4,s3
 85c:	6685                	lui	a3,0x1
 85e:	00d77363          	bgeu	a4,a3,864 <malloc+0x44>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86c:	00000917          	auipc	s2,0x0
 870:	79490913          	addi	s2,s2,1940 # 1000 <freep>
  if(p == (char*)-1)
 874:	5afd                	li	s5,-1
 876:	a88d                	j	8e8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 878:	00000797          	auipc	a5,0x0
 87c:	79878793          	addi	a5,a5,1944 # 1010 <base>
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
 888:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88e:	b7e1                	j	856 <malloc+0x36>
      if(p->s.size == nunits)
 890:	02e48b63          	beq	s1,a4,8c6 <malloc+0xa6>
        p->s.size -= nunits;
 894:	4137073b          	subw	a4,a4,s3
 898:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89a:	1702                	slli	a4,a4,0x20
 89c:	9301                	srli	a4,a4,0x20
 89e:	0712                	slli	a4,a4,0x4
 8a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	74a73d23          	sd	a0,1882(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b2:	70e2                	ld	ra,56(sp)
 8b4:	7442                	ld	s0,48(sp)
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	e118                	sd	a4,0(a0)
 8ca:	bff1                	j	8a6 <malloc+0x86>
  hp->s.size = nu;
 8cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d0:	0541                	addi	a0,a0,16
 8d2:	00000097          	auipc	ra,0x0
 8d6:	ec6080e7          	jalr	-314(ra) # 798 <free>
  return freep;
 8da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8de:	d971                	beqz	a0,8b2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	fa9776e3          	bgeu	a4,s1,890 <malloc+0x70>
    if(p == freep)
 8e8:	00093703          	ld	a4,0(s2)
 8ec:	853e                	mv	a0,a5
 8ee:	fef719e3          	bne	a4,a5,8e0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	00000097          	auipc	ra,0x0
 8f8:	b7e080e7          	jalr	-1154(ra) # 472 <sbrk>
  if(p == (char*)-1)
 8fc:	fd5518e3          	bne	a0,s5,8cc <malloc+0xac>
        return 0;
 900:	4501                	li	a0,0
 902:	bf45                	j	8b2 <malloc+0x92>
