
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	df010113          	addi	sp,sp,-528 # 80019df0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7d6050ef          	jal	ra,800057ec <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	ec078793          	addi	a5,a5,-320 # 80021ef0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a3090913          	addi	s2,s2,-1488 # 80008a80 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	192080e7          	jalr	402(ra) # 800061ec <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	232080e7          	jalr	562(ra) # 800062a0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c18080e7          	jalr	-1000(ra) # 80005ca2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	99450513          	addi	a0,a0,-1644 # 80008a80 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	068080e7          	jalr	104(ra) # 8000615c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	df050513          	addi	a0,a0,-528 # 80021ef0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	95e48493          	addi	s1,s1,-1698 # 80008a80 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0c0080e7          	jalr	192(ra) # 800061ec <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	94650513          	addi	a0,a0,-1722 # 80008a80 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	15c080e7          	jalr	348(ra) # 800062a0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	91a50513          	addi	a0,a0,-1766 # 80008a80 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	132080e7          	jalr	306(ra) # 800062a0 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	b56080e7          	jalr	-1194(ra) # 80000e84 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	71a70713          	addi	a4,a4,1818 # 80008a50 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	b3a080e7          	jalr	-1222(ra) # 80000e84 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	990080e7          	jalr	-1648(ra) # 80005cec <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7e8080e7          	jalr	2024(ra) # 80001b54 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dcc080e7          	jalr	-564(ra) # 80005140 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	032080e7          	jalr	50(ra) # 800013ae <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	830080e7          	jalr	-2000(ra) # 80005bb4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b46080e7          	jalr	-1210(ra) # 80005ed2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	950080e7          	jalr	-1712(ra) # 80005cec <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	940080e7          	jalr	-1728(ra) # 80005cec <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	930080e7          	jalr	-1744(ra) # 80005cec <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	34a080e7          	jalr	842(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9f4080e7          	jalr	-1548(ra) # 80000dd0 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	748080e7          	jalr	1864(ra) # 80001b2c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	768080e7          	jalr	1896(ra) # 80001b54 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d36080e7          	jalr	-714(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d44080e7          	jalr	-700(ra) # 80005140 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	efe080e7          	jalr	-258(ra) # 80002302 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5a2080e7          	jalr	1442(ra) # 800029ae <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	540080e7          	jalr	1344(ra) # 80003954 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e2c080e7          	jalr	-468(ra) # 80005248 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d68080e7          	jalr	-664(ra) # 8000118c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	60f72f23          	sw	a5,1566(a4) # 80008a50 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	6127b783          	ld	a5,1554(a5) # 80008a58 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	810080e7          	jalr	-2032(ra) # 80005ca2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000562:	03459793          	slli	a5,a1,0x34
    80000566:	e385                	bnez	a5,80000586 <mappages+0x3a>
    80000568:	8aaa                	mv	s5,a0
    8000056a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000056c:	03461793          	slli	a5,a2,0x34
    80000570:	e39d                	bnez	a5,80000596 <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000572:	ca15                	beqz	a2,800005a6 <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000574:	79fd                	lui	s3,0xfffff
    80000576:	964e                	add	a2,a2,s3
    80000578:	00b609b3          	add	s3,a2,a1
  a = va;
    8000057c:	892e                	mv	s2,a1
    8000057e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000582:	6b85                	lui	s7,0x1
    80000584:	a091                	j	800005c8 <mappages+0x7c>
    panic("mappages: va not aligned");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ad250513          	addi	a0,a0,-1326 # 80008058 <etext+0x58>
    8000058e:	00005097          	auipc	ra,0x5
    80000592:	714080e7          	jalr	1812(ra) # 80005ca2 <panic>
    panic("mappages: size not aligned");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ae250513          	addi	a0,a0,-1310 # 80008078 <etext+0x78>
    8000059e:	00005097          	auipc	ra,0x5
    800005a2:	704080e7          	jalr	1796(ra) # 80005ca2 <panic>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	af250513          	addi	a0,a0,-1294 # 80008098 <etext+0x98>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	6f4080e7          	jalr	1780(ra) # 80005ca2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	af250513          	addi	a0,a0,-1294 # 800080a8 <etext+0xa8>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	6e4080e7          	jalr	1764(ra) # 80005ca2 <panic>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
  for(;;){
    800005c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	e92080e7          	jalr	-366(ra) # 80000464 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0xac>
    if(*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbf9                	bnez	a5,800005b6 <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0xae>
      return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2e080e7          	jalr	-210(ra) # 8000054c <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
    panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a8850513          	addi	a0,a0,-1400 # 800080b8 <etext+0xb8>
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	66a080e7          	jalr	1642(ra) # 80005ca2 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b1e080e7          	jalr	-1250(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	63a080e7          	jalr	1594(ra) # 80000d3a <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	32a7b923          	sd	a0,818(a5) # 80008a58 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000760:	6b05                	lui	s6,0x1
    80000762:	0735e863          	bltu	a1,s3,800007d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	51e080e7          	jalr	1310(ra) # 80005ca2 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	94c50513          	addi	a0,a0,-1716 # 800080d8 <etext+0xd8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	50e080e7          	jalr	1294(ra) # 80005ca2 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	94c50513          	addi	a0,a0,-1716 # 800080e8 <etext+0xe8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	4fe080e7          	jalr	1278(ra) # 80005ca2 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	95450513          	addi	a0,a0,-1708 # 80008100 <etext+0x100>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	4ee080e7          	jalr	1262(ra) # 80005ca2 <panic>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	f9397ce3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	c8c080e7          	jalr	-884(ra) # 80000464 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d54d                	beqz	a0,8000078c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dbcd                	beqz	a5,8000079c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fb778ee3          	beq	a5,s7,800007ac <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x92>
    800007f8:	b7d1                	j	800007bc <uvmunmap+0x86>

00000000800007fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	914080e7          	jalr	-1772(ra) # 80000118 <kalloc>
    8000080c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080e:	c519                	beqz	a0,8000081c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000810:	6605                	lui	a2,0x1
    80000812:	4581                	li	a1,0
    80000814:	00000097          	auipc	ra,0x0
    80000818:	964080e7          	jalr	-1692(ra) # 80000178 <memset>
  return pagetable;
}
    8000081c:	8526                	mv	a0,s1
    8000081e:	60e2                	ld	ra,24(sp)
    80000820:	6442                	ld	s0,16(sp)
    80000822:	64a2                	ld	s1,8(sp)
    80000824:	6105                	addi	sp,sp,32
    80000826:	8082                	ret

0000000080000828 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000828:	7179                	addi	sp,sp,-48
    8000082a:	f406                	sd	ra,40(sp)
    8000082c:	f022                	sd	s0,32(sp)
    8000082e:	ec26                	sd	s1,24(sp)
    80000830:	e84a                	sd	s2,16(sp)
    80000832:	e44e                	sd	s3,8(sp)
    80000834:	e052                	sd	s4,0(sp)
    80000836:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000838:	6785                	lui	a5,0x1
    8000083a:	04f67863          	bgeu	a2,a5,8000088a <uvmfirst+0x62>
    8000083e:	8a2a                	mv	s4,a0
    80000840:	89ae                	mv	s3,a1
    80000842:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	8d4080e7          	jalr	-1836(ra) # 80000118 <kalloc>
    8000084c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084e:	6605                	lui	a2,0x1
    80000850:	4581                	li	a1,0
    80000852:	00000097          	auipc	ra,0x0
    80000856:	926080e7          	jalr	-1754(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085a:	4779                	li	a4,30
    8000085c:	86ca                	mv	a3,s2
    8000085e:	6605                	lui	a2,0x1
    80000860:	4581                	li	a1,0
    80000862:	8552                	mv	a0,s4
    80000864:	00000097          	auipc	ra,0x0
    80000868:	ce8080e7          	jalr	-792(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    8000086c:	8626                	mv	a2,s1
    8000086e:	85ce                	mv	a1,s3
    80000870:	854a                	mv	a0,s2
    80000872:	00000097          	auipc	ra,0x0
    80000876:	966080e7          	jalr	-1690(ra) # 800001d8 <memmove>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	88e50513          	addi	a0,a0,-1906 # 80008118 <etext+0x118>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	410080e7          	jalr	1040(ra) # 80005ca2 <panic>

000000008000089a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089a:	1101                	addi	sp,sp,-32
    8000089c:	ec06                	sd	ra,24(sp)
    8000089e:	e822                	sd	s0,16(sp)
    800008a0:	e426                	sd	s1,8(sp)
    800008a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a6:	00b67d63          	bgeu	a2,a1,800008c0 <uvmdealloc+0x26>
    800008aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ac:	6785                	lui	a5,0x1
    800008ae:	17fd                	addi	a5,a5,-1
    800008b0:	00f60733          	add	a4,a2,a5
    800008b4:	767d                	lui	a2,0xfffff
    800008b6:	8f71                	and	a4,a4,a2
    800008b8:	97ae                	add	a5,a5,a1
    800008ba:	8ff1                	and	a5,a5,a2
    800008bc:	00f76863          	bltu	a4,a5,800008cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c0:	8526                	mv	a0,s1
    800008c2:	60e2                	ld	ra,24(sp)
    800008c4:	6442                	ld	s0,16(sp)
    800008c6:	64a2                	ld	s1,8(sp)
    800008c8:	6105                	addi	sp,sp,32
    800008ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008cc:	8f99                	sub	a5,a5,a4
    800008ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d0:	4685                	li	a3,1
    800008d2:	0007861b          	sext.w	a2,a5
    800008d6:	85ba                	mv	a1,a4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	e5e080e7          	jalr	-418(ra) # 80000736 <uvmunmap>
    800008e0:	b7c5                	j	800008c0 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	0ab66563          	bltu	a2,a1,8000098c <uvmalloc+0xaa>
{
    800008e6:	7139                	addi	sp,sp,-64
    800008e8:	fc06                	sd	ra,56(sp)
    800008ea:	f822                	sd	s0,48(sp)
    800008ec:	f426                	sd	s1,40(sp)
    800008ee:	f04a                	sd	s2,32(sp)
    800008f0:	ec4e                	sd	s3,24(sp)
    800008f2:	e852                	sd	s4,16(sp)
    800008f4:	e456                	sd	s5,8(sp)
    800008f6:	e05a                	sd	s6,0(sp)
    800008f8:	0080                	addi	s0,sp,64
    800008fa:	8aaa                	mv	s5,a0
    800008fc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fe:	6985                	lui	s3,0x1
    80000900:	19fd                	addi	s3,s3,-1
    80000902:	95ce                	add	a1,a1,s3
    80000904:	79fd                	lui	s3,0xfffff
    80000906:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	08c9f363          	bgeu	s3,a2,80000990 <uvmalloc+0xae>
    8000090e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000910:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000914:	00000097          	auipc	ra,0x0
    80000918:	804080e7          	jalr	-2044(ra) # 80000118 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c51d                	beqz	a0,8000094c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000920:	6605                	lui	a2,0x1
    80000922:	4581                	li	a1,0
    80000924:	00000097          	auipc	ra,0x0
    80000928:	854080e7          	jalr	-1964(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092c:	875a                	mv	a4,s6
    8000092e:	86a6                	mv	a3,s1
    80000930:	6605                	lui	a2,0x1
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	c16080e7          	jalr	-1002(ra) # 8000054c <mappages>
    8000093e:	e90d                	bnez	a0,80000970 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000940:	6785                	lui	a5,0x1
    80000942:	993e                	add	s2,s2,a5
    80000944:	fd4968e3          	bltu	s2,s4,80000914 <uvmalloc+0x32>
  return newsz;
    80000948:	8552                	mv	a0,s4
    8000094a:	a809                	j	8000095c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094c:	864e                	mv	a2,s3
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	f48080e7          	jalr	-184(ra) # 8000089a <uvmdealloc>
      return 0;
    8000095a:	4501                	li	a0,0
}
    8000095c:	70e2                	ld	ra,56(sp)
    8000095e:	7442                	ld	s0,48(sp)
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	69e2                	ld	s3,24(sp)
    80000966:	6a42                	ld	s4,16(sp)
    80000968:	6aa2                	ld	s5,8(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret
      kfree(mem);
    80000970:	8526                	mv	a0,s1
    80000972:	fffff097          	auipc	ra,0xfffff
    80000976:	6aa080e7          	jalr	1706(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f1a080e7          	jalr	-230(ra) # 8000089a <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
    8000098a:	bfc9                	j	8000095c <uvmalloc+0x7a>
    return oldsz;
    8000098c:	852e                	mv	a0,a1
}
    8000098e:	8082                	ret
  return newsz;
    80000990:	8532                	mv	a0,a2
    80000992:	b7e9                	j	8000095c <uvmalloc+0x7a>

0000000080000994 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000994:	7179                	addi	sp,sp,-48
    80000996:	f406                	sd	ra,40(sp)
    80000998:	f022                	sd	s0,32(sp)
    8000099a:	ec26                	sd	s1,24(sp)
    8000099c:	e84a                	sd	s2,16(sp)
    8000099e:	e44e                	sd	s3,8(sp)
    800009a0:	e052                	sd	s4,0(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a6:	84aa                	mv	s1,a0
    800009a8:	6905                	lui	s2,0x1
    800009aa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ac:	4985                	li	s3,1
    800009ae:	a821                	j	800009c6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b2:	0532                	slli	a0,a0,0xc
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	fe0080e7          	jalr	-32(ra) # 80000994 <freewalk>
      pagetable[i] = 0;
    800009bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c0:	04a1                	addi	s1,s1,8
    800009c2:	03248163          	beq	s1,s2,800009e4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c8:	00f57793          	andi	a5,a0,15
    800009cc:	ff3782e3          	beq	a5,s3,800009b0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d0:	8905                	andi	a0,a0,1
    800009d2:	d57d                	beqz	a0,800009c0 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d4:	00007517          	auipc	a0,0x7
    800009d8:	76450513          	addi	a0,a0,1892 # 80008138 <etext+0x138>
    800009dc:	00005097          	auipc	ra,0x5
    800009e0:	2c6080e7          	jalr	710(ra) # 80005ca2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e4:	8552                	mv	a0,s4
    800009e6:	fffff097          	auipc	ra,0xfffff
    800009ea:	636080e7          	jalr	1590(ra) # 8000001c <kfree>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0a:	e999                	bnez	a1,80000a20 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	f86080e7          	jalr	-122(ra) # 80000994 <freewalk>
}
    80000a16:	60e2                	ld	ra,24(sp)
    80000a18:	6442                	ld	s0,16(sp)
    80000a1a:	64a2                	ld	s1,8(sp)
    80000a1c:	6105                	addi	sp,sp,32
    80000a1e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	167d                	addi	a2,a2,-1
    80000a24:	962e                	add	a2,a2,a1
    80000a26:	4685                	li	a3,1
    80000a28:	8231                	srli	a2,a2,0xc
    80000a2a:	4581                	li	a1,0
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	d0a080e7          	jalr	-758(ra) # 80000736 <uvmunmap>
    80000a34:	bfe1                	j	80000a0c <uvmfree+0xe>

0000000080000a36 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	c679                	beqz	a2,80000b04 <uvmcopy+0xce>
{
    80000a38:	715d                	addi	sp,sp,-80
    80000a3a:	e486                	sd	ra,72(sp)
    80000a3c:	e0a2                	sd	s0,64(sp)
    80000a3e:	fc26                	sd	s1,56(sp)
    80000a40:	f84a                	sd	s2,48(sp)
    80000a42:	f44e                	sd	s3,40(sp)
    80000a44:	f052                	sd	s4,32(sp)
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e45e                	sd	s7,8(sp)
    80000a4c:	0880                	addi	s0,sp,80
    80000a4e:	8b2a                	mv	s6,a0
    80000a50:	8aae                	mv	s5,a1
    80000a52:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a56:	4601                	li	a2,0
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	855a                	mv	a0,s6
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	a08080e7          	jalr	-1528(ra) # 80000464 <walk>
    80000a64:	c531                	beqz	a0,80000ab0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a66:	6118                	ld	a4,0(a0)
    80000a68:	00177793          	andi	a5,a4,1
    80000a6c:	cbb1                	beqz	a5,80000ac0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6e:	00a75593          	srli	a1,a4,0xa
    80000a72:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a76:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	69e080e7          	jalr	1694(ra) # 80000118 <kalloc>
    80000a82:	892a                	mv	s2,a0
    80000a84:	c939                	beqz	a0,80000ada <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	85de                	mv	a1,s7
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a92:	8726                	mv	a4,s1
    80000a94:	86ca                	mv	a3,s2
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ce                	mv	a1,s3
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	ab0080e7          	jalr	-1360(ra) # 8000054c <mappages>
    80000aa4:	e515                	bnez	a0,80000ad0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	99be                	add	s3,s3,a5
    80000aaa:	fb49e6e3          	bltu	s3,s4,80000a56 <uvmcopy+0x20>
    80000aae:	a081                	j	80000aee <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	69850513          	addi	a0,a0,1688 # 80008148 <etext+0x148>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	1ea080e7          	jalr	490(ra) # 80005ca2 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	6a850513          	addi	a0,a0,1704 # 80008168 <etext+0x168>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	1da080e7          	jalr	474(ra) # 80005ca2 <panic>
      kfree(mem);
    80000ad0:	854a                	mv	a0,s2
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	54a080e7          	jalr	1354(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ada:	4685                	li	a3,1
    80000adc:	00c9d613          	srli	a2,s3,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	8556                	mv	a0,s5
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	c52080e7          	jalr	-942(ra) # 80000736 <uvmunmap>
  return -1;
    80000aec:	557d                	li	a0,-1
}
    80000aee:	60a6                	ld	ra,72(sp)
    80000af0:	6406                	ld	s0,64(sp)
    80000af2:	74e2                	ld	s1,56(sp)
    80000af4:	7942                	ld	s2,48(sp)
    80000af6:	79a2                	ld	s3,40(sp)
    80000af8:	7a02                	ld	s4,32(sp)
    80000afa:	6ae2                	ld	s5,24(sp)
    80000afc:	6b42                	ld	s6,16(sp)
    80000afe:	6ba2                	ld	s7,8(sp)
    80000b00:	6161                	addi	sp,sp,80
    80000b02:	8082                	ret
  return 0;
    80000b04:	4501                	li	a0,0
}
    80000b06:	8082                	ret

0000000080000b08 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b08:	1141                	addi	sp,sp,-16
    80000b0a:	e406                	sd	ra,8(sp)
    80000b0c:	e022                	sd	s0,0(sp)
    80000b0e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	952080e7          	jalr	-1710(ra) # 80000464 <walk>
  if(pte == 0)
    80000b1a:	c901                	beqz	a0,80000b2a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	9bbd                	andi	a5,a5,-17
    80000b20:	e11c                	sd	a5,0(a0)
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret
    panic("uvmclear");
    80000b2a:	00007517          	auipc	a0,0x7
    80000b2e:	65e50513          	addi	a0,a0,1630 # 80008188 <etext+0x188>
    80000b32:	00005097          	auipc	ra,0x5
    80000b36:	170080e7          	jalr	368(ra) # 80005ca2 <panic>

0000000080000b3a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b3a:	cac9                	beqz	a3,80000bcc <copyout+0x92>
{
    80000b3c:	711d                	addi	sp,sp,-96
    80000b3e:	ec86                	sd	ra,88(sp)
    80000b40:	e8a2                	sd	s0,80(sp)
    80000b42:	e4a6                	sd	s1,72(sp)
    80000b44:	e0ca                	sd	s2,64(sp)
    80000b46:	fc4e                	sd	s3,56(sp)
    80000b48:	f852                	sd	s4,48(sp)
    80000b4a:	f456                	sd	s5,40(sp)
    80000b4c:	f05a                	sd	s6,32(sp)
    80000b4e:	ec5e                	sd	s7,24(sp)
    80000b50:	e862                	sd	s8,16(sp)
    80000b52:	e466                	sd	s9,8(sp)
    80000b54:	e06a                	sd	s10,0(sp)
    80000b56:	1080                	addi	s0,sp,96
    80000b58:	8baa                	mv	s7,a0
    80000b5a:	8aae                	mv	s5,a1
    80000b5c:	8b32                	mv	s6,a2
    80000b5e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b60:	74fd                	lui	s1,0xfffff
    80000b62:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b64:	57fd                	li	a5,-1
    80000b66:	83e9                	srli	a5,a5,0x1a
    80000b68:	0697e463          	bltu	a5,s1,80000bd0 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b6c:	4cd5                	li	s9,21
    80000b6e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b70:	8c3e                	mv	s8,a5
    80000b72:	a035                	j	80000b9e <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b74:	83a9                	srli	a5,a5,0xa
    80000b76:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b78:	409a8533          	sub	a0,s5,s1
    80000b7c:	0009061b          	sext.w	a2,s2
    80000b80:	85da                	mv	a1,s6
    80000b82:	953e                	add	a0,a0,a5
    80000b84:	fffff097          	auipc	ra,0xfffff
    80000b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>

    len -= n;
    80000b8c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b90:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b92:	02098b63          	beqz	s3,80000bc8 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b96:	034c6f63          	bltu	s8,s4,80000bd4 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b9a:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b9c:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9e:	4601                	li	a2,0
    80000ba0:	85a6                	mv	a1,s1
    80000ba2:	855e                	mv	a0,s7
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	8c0080e7          	jalr	-1856(ra) # 80000464 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bac:	c515                	beqz	a0,80000bd8 <copyout+0x9e>
    80000bae:	611c                	ld	a5,0(a0)
    80000bb0:	0157f713          	andi	a4,a5,21
    80000bb4:	05971163          	bne	a4,s9,80000bf6 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb8:	01a48a33          	add	s4,s1,s10
    80000bbc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bc0:	fb29fae3          	bgeu	s3,s2,80000b74 <copyout+0x3a>
    80000bc4:	894e                	mv	s2,s3
    80000bc6:	b77d                	j	80000b74 <copyout+0x3a>
  }
  return 0;
    80000bc8:	4501                	li	a0,0
    80000bca:	a801                	j	80000bda <copyout+0xa0>
    80000bcc:	4501                	li	a0,0
}
    80000bce:	8082                	ret
      return -1;
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a021                	j	80000bda <copyout+0xa0>
    80000bd4:	557d                	li	a0,-1
    80000bd6:	a011                	j	80000bda <copyout+0xa0>
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60e6                	ld	ra,88(sp)
    80000bdc:	6446                	ld	s0,80(sp)
    80000bde:	64a6                	ld	s1,72(sp)
    80000be0:	6906                	ld	s2,64(sp)
    80000be2:	79e2                	ld	s3,56(sp)
    80000be4:	7a42                	ld	s4,48(sp)
    80000be6:	7aa2                	ld	s5,40(sp)
    80000be8:	7b02                	ld	s6,32(sp)
    80000bea:	6be2                	ld	s7,24(sp)
    80000bec:	6c42                	ld	s8,16(sp)
    80000bee:	6ca2                	ld	s9,8(sp)
    80000bf0:	6d02                	ld	s10,0(sp)
    80000bf2:	6125                	addi	sp,sp,96
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
    80000bf8:	b7cd                	j	80000bda <copyout+0xa0>

0000000080000bfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bfa:	c6bd                	beqz	a3,80000c68 <copyin+0x6e>
{
    80000bfc:	715d                	addi	sp,sp,-80
    80000bfe:	e486                	sd	ra,72(sp)
    80000c00:	e0a2                	sd	s0,64(sp)
    80000c02:	fc26                	sd	s1,56(sp)
    80000c04:	f84a                	sd	s2,48(sp)
    80000c06:	f44e                	sd	s3,40(sp)
    80000c08:	f052                	sd	s4,32(sp)
    80000c0a:	ec56                	sd	s5,24(sp)
    80000c0c:	e85a                	sd	s6,16(sp)
    80000c0e:	e45e                	sd	s7,8(sp)
    80000c10:	e062                	sd	s8,0(sp)
    80000c12:	0880                	addi	s0,sp,80
    80000c14:	8b2a                	mv	s6,a0
    80000c16:	8a2e                	mv	s4,a1
    80000c18:	8c32                	mv	s8,a2
    80000c1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1e:	6a85                	lui	s5,0x1
    80000c20:	a015                	j	80000c44 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c22:	9562                	add	a0,a0,s8
    80000c24:	0004861b          	sext.w	a2,s1
    80000c28:	412505b3          	sub	a1,a0,s2
    80000c2c:	8552                	mv	a0,s4
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	5aa080e7          	jalr	1450(ra) # 800001d8 <memmove>

    len -= n;
    80000c36:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c40:	02098263          	beqz	s3,80000c64 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c48:	85ca                	mv	a1,s2
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8be080e7          	jalr	-1858(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c54:	cd01                	beqz	a0,80000c6c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c56:	418904b3          	sub	s1,s2,s8
    80000c5a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c5c:	fc99f3e3          	bgeu	s3,s1,80000c22 <copyin+0x28>
    80000c60:	84ce                	mv	s1,s3
    80000c62:	b7c1                	j	80000c22 <copyin+0x28>
  }
  return 0;
    80000c64:	4501                	li	a0,0
    80000c66:	a021                	j	80000c6e <copyin+0x74>
    80000c68:	4501                	li	a0,0
}
    80000c6a:	8082                	ret
      return -1;
    80000c6c:	557d                	li	a0,-1
}
    80000c6e:	60a6                	ld	ra,72(sp)
    80000c70:	6406                	ld	s0,64(sp)
    80000c72:	74e2                	ld	s1,56(sp)
    80000c74:	7942                	ld	s2,48(sp)
    80000c76:	79a2                	ld	s3,40(sp)
    80000c78:	7a02                	ld	s4,32(sp)
    80000c7a:	6ae2                	ld	s5,24(sp)
    80000c7c:	6b42                	ld	s6,16(sp)
    80000c7e:	6ba2                	ld	s7,8(sp)
    80000c80:	6c02                	ld	s8,0(sp)
    80000c82:	6161                	addi	sp,sp,80
    80000c84:	8082                	ret

0000000080000c86 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c86:	c6c5                	beqz	a3,80000d2e <copyinstr+0xa8>
{
    80000c88:	715d                	addi	sp,sp,-80
    80000c8a:	e486                	sd	ra,72(sp)
    80000c8c:	e0a2                	sd	s0,64(sp)
    80000c8e:	fc26                	sd	s1,56(sp)
    80000c90:	f84a                	sd	s2,48(sp)
    80000c92:	f44e                	sd	s3,40(sp)
    80000c94:	f052                	sd	s4,32(sp)
    80000c96:	ec56                	sd	s5,24(sp)
    80000c98:	e85a                	sd	s6,16(sp)
    80000c9a:	e45e                	sd	s7,8(sp)
    80000c9c:	0880                	addi	s0,sp,80
    80000c9e:	8a2a                	mv	s4,a0
    80000ca0:	8b2e                	mv	s6,a1
    80000ca2:	8bb2                	mv	s7,a2
    80000ca4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca8:	6985                	lui	s3,0x1
    80000caa:	a035                	j	80000cd6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cba:	60a6                	ld	ra,72(sp)
    80000cbc:	6406                	ld	s0,64(sp)
    80000cbe:	74e2                	ld	s1,56(sp)
    80000cc0:	7942                	ld	s2,48(sp)
    80000cc2:	79a2                	ld	s3,40(sp)
    80000cc4:	7a02                	ld	s4,32(sp)
    80000cc6:	6ae2                	ld	s5,24(sp)
    80000cc8:	6b42                	ld	s6,16(sp)
    80000cca:	6ba2                	ld	s7,8(sp)
    80000ccc:	6161                	addi	sp,sp,80
    80000cce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd4:	c8a9                	beqz	s1,80000d26 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cda:	85ca                	mv	a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	82c080e7          	jalr	-2004(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000ce6:	c131                	beqz	a0,80000d2a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce8:	41790833          	sub	a6,s2,s7
    80000cec:	984e                	add	a6,a6,s3
    if(n > max)
    80000cee:	0104f363          	bgeu	s1,a6,80000cf4 <copyinstr+0x6e>
    80000cf2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf4:	955e                	add	a0,a0,s7
    80000cf6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfa:	fc080be3          	beqz	a6,80000cd0 <copyinstr+0x4a>
    80000cfe:	985a                	add	a6,a6,s6
    80000d00:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d02:	41650633          	sub	a2,a0,s6
    80000d06:	14fd                	addi	s1,s1,-1
    80000d08:	9b26                	add	s6,s6,s1
    80000d0a:	00f60733          	add	a4,a2,a5
    80000d0e:	00074703          	lbu	a4,0(a4)
    80000d12:	df49                	beqz	a4,80000cac <copyinstr+0x26>
        *dst = *p;
    80000d14:	00e78023          	sb	a4,0(a5)
      --max;
    80000d18:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d1c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d1e:	ff0796e3          	bne	a5,a6,80000d0a <copyinstr+0x84>
      dst++;
    80000d22:	8b42                	mv	s6,a6
    80000d24:	b775                	j	80000cd0 <copyinstr+0x4a>
    80000d26:	4781                	li	a5,0
    80000d28:	b769                	j	80000cb2 <copyinstr+0x2c>
      return -1;
    80000d2a:	557d                	li	a0,-1
    80000d2c:	b779                	j	80000cba <copyinstr+0x34>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	0017b793          	seqz	a5,a5
    80000d34:	40f00533          	neg	a0,a5
}
    80000d38:	8082                	ret

0000000080000d3a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d3a:	7139                	addi	sp,sp,-64
    80000d3c:	fc06                	sd	ra,56(sp)
    80000d3e:	f822                	sd	s0,48(sp)
    80000d40:	f426                	sd	s1,40(sp)
    80000d42:	f04a                	sd	s2,32(sp)
    80000d44:	ec4e                	sd	s3,24(sp)
    80000d46:	e852                	sd	s4,16(sp)
    80000d48:	e456                	sd	s5,8(sp)
    80000d4a:	e05a                	sd	s6,0(sp)
    80000d4c:	0080                	addi	s0,sp,64
    80000d4e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	00008497          	auipc	s1,0x8
    80000d54:	18048493          	addi	s1,s1,384 # 80008ed0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	8b26                	mv	s6,s1
    80000d5a:	00007a97          	auipc	s5,0x7
    80000d5e:	2a6a8a93          	addi	s5,s5,678 # 80008000 <etext>
    80000d62:	04000937          	lui	s2,0x4000
    80000d66:	197d                	addi	s2,s2,-1
    80000d68:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d6a:	0000ea17          	auipc	s4,0xe
    80000d6e:	b66a0a13          	addi	s4,s4,-1178 # 8000e8d0 <tickslock>
    char *pa = kalloc();
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	3a6080e7          	jalr	934(ra) # 80000118 <kalloc>
    80000d7a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d7c:	c131                	beqz	a0,80000dc0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d7e:	416485b3          	sub	a1,s1,s6
    80000d82:	858d                	srai	a1,a1,0x3
    80000d84:	000ab783          	ld	a5,0(s5)
    80000d88:	02f585b3          	mul	a1,a1,a5
    80000d8c:	2585                	addiw	a1,a1,1
    80000d8e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d92:	4719                	li	a4,6
    80000d94:	6685                	lui	a3,0x1
    80000d96:	40b905b3          	sub	a1,s2,a1
    80000d9a:	854e                	mv	a0,s3
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	874080e7          	jalr	-1932(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da4:	16848493          	addi	s1,s1,360
    80000da8:	fd4495e3          	bne	s1,s4,80000d72 <proc_mapstacks+0x38>
  }
}
    80000dac:	70e2                	ld	ra,56(sp)
    80000dae:	7442                	ld	s0,48(sp)
    80000db0:	74a2                	ld	s1,40(sp)
    80000db2:	7902                	ld	s2,32(sp)
    80000db4:	69e2                	ld	s3,24(sp)
    80000db6:	6a42                	ld	s4,16(sp)
    80000db8:	6aa2                	ld	s5,8(sp)
    80000dba:	6b02                	ld	s6,0(sp)
    80000dbc:	6121                	addi	sp,sp,64
    80000dbe:	8082                	ret
      panic("kalloc");
    80000dc0:	00007517          	auipc	a0,0x7
    80000dc4:	3d850513          	addi	a0,a0,984 # 80008198 <etext+0x198>
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	eda080e7          	jalr	-294(ra) # 80005ca2 <panic>

0000000080000dd0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dd0:	7139                	addi	sp,sp,-64
    80000dd2:	fc06                	sd	ra,56(sp)
    80000dd4:	f822                	sd	s0,48(sp)
    80000dd6:	f426                	sd	s1,40(sp)
    80000dd8:	f04a                	sd	s2,32(sp)
    80000dda:	ec4e                	sd	s3,24(sp)
    80000ddc:	e852                	sd	s4,16(sp)
    80000dde:	e456                	sd	s5,8(sp)
    80000de0:	e05a                	sd	s6,0(sp)
    80000de2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000de4:	00007597          	auipc	a1,0x7
    80000de8:	3bc58593          	addi	a1,a1,956 # 800081a0 <etext+0x1a0>
    80000dec:	00008517          	auipc	a0,0x8
    80000df0:	cb450513          	addi	a0,a0,-844 # 80008aa0 <pid_lock>
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	368080e7          	jalr	872(ra) # 8000615c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dfc:	00007597          	auipc	a1,0x7
    80000e00:	3ac58593          	addi	a1,a1,940 # 800081a8 <etext+0x1a8>
    80000e04:	00008517          	auipc	a0,0x8
    80000e08:	cb450513          	addi	a0,a0,-844 # 80008ab8 <wait_lock>
    80000e0c:	00005097          	auipc	ra,0x5
    80000e10:	350080e7          	jalr	848(ra) # 8000615c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	00008497          	auipc	s1,0x8
    80000e18:	0bc48493          	addi	s1,s1,188 # 80008ed0 <proc>
      initlock(&p->lock, "proc");
    80000e1c:	00007b17          	auipc	s6,0x7
    80000e20:	39cb0b13          	addi	s6,s6,924 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e24:	8aa6                	mv	s5,s1
    80000e26:	00007a17          	auipc	s4,0x7
    80000e2a:	1daa0a13          	addi	s4,s4,474 # 80008000 <etext>
    80000e2e:	04000937          	lui	s2,0x4000
    80000e32:	197d                	addi	s2,s2,-1
    80000e34:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	0000e997          	auipc	s3,0xe
    80000e3a:	a9a98993          	addi	s3,s3,-1382 # 8000e8d0 <tickslock>
      initlock(&p->lock, "proc");
    80000e3e:	85da                	mv	a1,s6
    80000e40:	8526                	mv	a0,s1
    80000e42:	00005097          	auipc	ra,0x5
    80000e46:	31a080e7          	jalr	794(ra) # 8000615c <initlock>
      p->state = UNUSED;
    80000e4a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e4e:	415487b3          	sub	a5,s1,s5
    80000e52:	878d                	srai	a5,a5,0x3
    80000e54:	000a3703          	ld	a4,0(s4)
    80000e58:	02e787b3          	mul	a5,a5,a4
    80000e5c:	2785                	addiw	a5,a5,1
    80000e5e:	00d7979b          	slliw	a5,a5,0xd
    80000e62:	40f907b3          	sub	a5,s2,a5
    80000e66:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e68:	16848493          	addi	s1,s1,360
    80000e6c:	fd3499e3          	bne	s1,s3,80000e3e <procinit+0x6e>
  }
}
    80000e70:	70e2                	ld	ra,56(sp)
    80000e72:	7442                	ld	s0,48(sp)
    80000e74:	74a2                	ld	s1,40(sp)
    80000e76:	7902                	ld	s2,32(sp)
    80000e78:	69e2                	ld	s3,24(sp)
    80000e7a:	6a42                	ld	s4,16(sp)
    80000e7c:	6aa2                	ld	s5,8(sp)
    80000e7e:	6b02                	ld	s6,0(sp)
    80000e80:	6121                	addi	sp,sp,64
    80000e82:	8082                	ret

0000000080000e84 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e422                	sd	s0,8(sp)
    80000e88:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e8a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e8c:	2501                	sext.w	a0,a0
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
    80000e9a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ea0:	00008517          	auipc	a0,0x8
    80000ea4:	c3050513          	addi	a0,a0,-976 # 80008ad0 <cpus>
    80000ea8:	953e                	add	a0,a0,a5
    80000eaa:	6422                	ld	s0,8(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret

0000000080000eb0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eb0:	1101                	addi	sp,sp,-32
    80000eb2:	ec06                	sd	ra,24(sp)
    80000eb4:	e822                	sd	s0,16(sp)
    80000eb6:	e426                	sd	s1,8(sp)
    80000eb8:	1000                	addi	s0,sp,32
  push_off();
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	2e6080e7          	jalr	742(ra) # 800061a0 <push_off>
    80000ec2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ec4:	2781                	sext.w	a5,a5
    80000ec6:	079e                	slli	a5,a5,0x7
    80000ec8:	00008717          	auipc	a4,0x8
    80000ecc:	bd870713          	addi	a4,a4,-1064 # 80008aa0 <pid_lock>
    80000ed0:	97ba                	add	a5,a5,a4
    80000ed2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	36c080e7          	jalr	876(ra) # 80006240 <pop_off>
  return p;
}
    80000edc:	8526                	mv	a0,s1
    80000ede:	60e2                	ld	ra,24(sp)
    80000ee0:	6442                	ld	s0,16(sp)
    80000ee2:	64a2                	ld	s1,8(sp)
    80000ee4:	6105                	addi	sp,sp,32
    80000ee6:	8082                	ret

0000000080000ee8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee8:	1141                	addi	sp,sp,-16
    80000eea:	e406                	sd	ra,8(sp)
    80000eec:	e022                	sd	s0,0(sp)
    80000eee:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	fc0080e7          	jalr	-64(ra) # 80000eb0 <myproc>
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	3a8080e7          	jalr	936(ra) # 800062a0 <release>

  if (first) {
    80000f00:	00008797          	auipc	a5,0x8
    80000f04:	b007a783          	lw	a5,-1280(a5) # 80008a00 <first.1679>
    80000f08:	eb89                	bnez	a5,80000f1a <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f0a:	00001097          	auipc	ra,0x1
    80000f0e:	c62080e7          	jalr	-926(ra) # 80001b6c <usertrapret>
}
    80000f12:	60a2                	ld	ra,8(sp)
    80000f14:	6402                	ld	s0,0(sp)
    80000f16:	0141                	addi	sp,sp,16
    80000f18:	8082                	ret
    fsinit(ROOTDEV);
    80000f1a:	4505                	li	a0,1
    80000f1c:	00002097          	auipc	ra,0x2
    80000f20:	a12080e7          	jalr	-1518(ra) # 8000292e <fsinit>
    first = 0;
    80000f24:	00008797          	auipc	a5,0x8
    80000f28:	ac07ae23          	sw	zero,-1316(a5) # 80008a00 <first.1679>
    __sync_synchronize();
    80000f2c:	0ff0000f          	fence
    80000f30:	bfe9                	j	80000f0a <forkret+0x22>

0000000080000f32 <allocpid>:
{
    80000f32:	1101                	addi	sp,sp,-32
    80000f34:	ec06                	sd	ra,24(sp)
    80000f36:	e822                	sd	s0,16(sp)
    80000f38:	e426                	sd	s1,8(sp)
    80000f3a:	e04a                	sd	s2,0(sp)
    80000f3c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f3e:	00008917          	auipc	s2,0x8
    80000f42:	b6290913          	addi	s2,s2,-1182 # 80008aa0 <pid_lock>
    80000f46:	854a                	mv	a0,s2
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	2a4080e7          	jalr	676(ra) # 800061ec <acquire>
  pid = nextpid;
    80000f50:	00008797          	auipc	a5,0x8
    80000f54:	ab478793          	addi	a5,a5,-1356 # 80008a04 <nextpid>
    80000f58:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f5a:	0014871b          	addiw	a4,s1,1
    80000f5e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f60:	854a                	mv	a0,s2
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	33e080e7          	jalr	830(ra) # 800062a0 <release>
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6902                	ld	s2,0(sp)
    80000f74:	6105                	addi	sp,sp,32
    80000f76:	8082                	ret

0000000080000f78 <proc_pagetable>:
{
    80000f78:	1101                	addi	sp,sp,-32
    80000f7a:	ec06                	sd	ra,24(sp)
    80000f7c:	e822                	sd	s0,16(sp)
    80000f7e:	e426                	sd	s1,8(sp)
    80000f80:	e04a                	sd	s2,0(sp)
    80000f82:	1000                	addi	s0,sp,32
    80000f84:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	874080e7          	jalr	-1932(ra) # 800007fa <uvmcreate>
    80000f8e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f90:	c121                	beqz	a0,80000fd0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f92:	4729                	li	a4,10
    80000f94:	00006697          	auipc	a3,0x6
    80000f98:	06c68693          	addi	a3,a3,108 # 80007000 <_trampoline>
    80000f9c:	6605                	lui	a2,0x1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	5a6080e7          	jalr	1446(ra) # 8000054c <mappages>
    80000fae:	02054863          	bltz	a0,80000fde <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fb2:	4719                	li	a4,6
    80000fb4:	05893683          	ld	a3,88(s2)
    80000fb8:	6605                	lui	a2,0x1
    80000fba:	020005b7          	lui	a1,0x2000
    80000fbe:	15fd                	addi	a1,a1,-1
    80000fc0:	05b6                	slli	a1,a1,0xd
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	588080e7          	jalr	1416(ra) # 8000054c <mappages>
    80000fcc:	02054163          	bltz	a0,80000fee <proc_pagetable+0x76>
}
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	60e2                	ld	ra,24(sp)
    80000fd4:	6442                	ld	s0,16(sp)
    80000fd6:	64a2                	ld	s1,8(sp)
    80000fd8:	6902                	ld	s2,0(sp)
    80000fda:	6105                	addi	sp,sp,32
    80000fdc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fde:	4581                	li	a1,0
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	a1c080e7          	jalr	-1508(ra) # 800009fe <uvmfree>
    return 0;
    80000fea:	4481                	li	s1,0
    80000fec:	b7d5                	j	80000fd0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fee:	4681                	li	a3,0
    80000ff0:	4605                	li	a2,1
    80000ff2:	040005b7          	lui	a1,0x4000
    80000ff6:	15fd                	addi	a1,a1,-1
    80000ff8:	05b2                	slli	a1,a1,0xc
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	73a080e7          	jalr	1850(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80001004:	4581                	li	a1,0
    80001006:	8526                	mv	a0,s1
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	9f6080e7          	jalr	-1546(ra) # 800009fe <uvmfree>
    return 0;
    80001010:	4481                	li	s1,0
    80001012:	bf7d                	j	80000fd0 <proc_pagetable+0x58>

0000000080001014 <proc_freepagetable>:
{
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	e04a                	sd	s2,0(sp)
    8000101e:	1000                	addi	s0,sp,32
    80001020:	84aa                	mv	s1,a0
    80001022:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001024:	4681                	li	a3,0
    80001026:	4605                	li	a2,1
    80001028:	040005b7          	lui	a1,0x4000
    8000102c:	15fd                	addi	a1,a1,-1
    8000102e:	05b2                	slli	a1,a1,0xc
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	706080e7          	jalr	1798(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001038:	4681                	li	a3,0
    8000103a:	4605                	li	a2,1
    8000103c:	020005b7          	lui	a1,0x2000
    80001040:	15fd                	addi	a1,a1,-1
    80001042:	05b6                	slli	a1,a1,0xd
    80001044:	8526                	mv	a0,s1
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	6f0080e7          	jalr	1776(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    8000104e:	85ca                	mv	a1,s2
    80001050:	8526                	mv	a0,s1
    80001052:	00000097          	auipc	ra,0x0
    80001056:	9ac080e7          	jalr	-1620(ra) # 800009fe <uvmfree>
}
    8000105a:	60e2                	ld	ra,24(sp)
    8000105c:	6442                	ld	s0,16(sp)
    8000105e:	64a2                	ld	s1,8(sp)
    80001060:	6902                	ld	s2,0(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <freeproc>:
{
    80001066:	1101                	addi	sp,sp,-32
    80001068:	ec06                	sd	ra,24(sp)
    8000106a:	e822                	sd	s0,16(sp)
    8000106c:	e426                	sd	s1,8(sp)
    8000106e:	1000                	addi	s0,sp,32
    80001070:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001072:	6d28                	ld	a0,88(a0)
    80001074:	c509                	beqz	a0,8000107e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	fa6080e7          	jalr	-90(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000107e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001082:	68a8                	ld	a0,80(s1)
    80001084:	c511                	beqz	a0,80001090 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001086:	64ac                	ld	a1,72(s1)
    80001088:	00000097          	auipc	ra,0x0
    8000108c:	f8c080e7          	jalr	-116(ra) # 80001014 <proc_freepagetable>
  p->pagetable = 0;
    80001090:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001094:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001098:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000109c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010a0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010a4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010ac:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010b0:	0004ac23          	sw	zero,24(s1)
}
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret

00000000800010be <allocproc>:
{
    800010be:	1101                	addi	sp,sp,-32
    800010c0:	ec06                	sd	ra,24(sp)
    800010c2:	e822                	sd	s0,16(sp)
    800010c4:	e426                	sd	s1,8(sp)
    800010c6:	e04a                	sd	s2,0(sp)
    800010c8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ca:	00008497          	auipc	s1,0x8
    800010ce:	e0648493          	addi	s1,s1,-506 # 80008ed0 <proc>
    800010d2:	0000d917          	auipc	s2,0xd
    800010d6:	7fe90913          	addi	s2,s2,2046 # 8000e8d0 <tickslock>
    acquire(&p->lock);
    800010da:	8526                	mv	a0,s1
    800010dc:	00005097          	auipc	ra,0x5
    800010e0:	110080e7          	jalr	272(ra) # 800061ec <acquire>
    if(p->state == UNUSED) {
    800010e4:	4c9c                	lw	a5,24(s1)
    800010e6:	cf81                	beqz	a5,800010fe <allocproc+0x40>
      release(&p->lock);
    800010e8:	8526                	mv	a0,s1
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	1b6080e7          	jalr	438(ra) # 800062a0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010f2:	16848493          	addi	s1,s1,360
    800010f6:	ff2492e3          	bne	s1,s2,800010da <allocproc+0x1c>
  return 0;
    800010fa:	4481                	li	s1,0
    800010fc:	a889                	j	8000114e <allocproc+0x90>
  p->pid = allocpid();
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	e34080e7          	jalr	-460(ra) # 80000f32 <allocpid>
    80001106:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001108:	4785                	li	a5,1
    8000110a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	00c080e7          	jalr	12(ra) # 80000118 <kalloc>
    80001114:	892a                	mv	s2,a0
    80001116:	eca8                	sd	a0,88(s1)
    80001118:	c131                	beqz	a0,8000115c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	e5c080e7          	jalr	-420(ra) # 80000f78 <proc_pagetable>
    80001124:	892a                	mv	s2,a0
    80001126:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001128:	c531                	beqz	a0,80001174 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000112a:	07000613          	li	a2,112
    8000112e:	4581                	li	a1,0
    80001130:	06048513          	addi	a0,s1,96
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	044080e7          	jalr	68(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000113c:	00000797          	auipc	a5,0x0
    80001140:	dac78793          	addi	a5,a5,-596 # 80000ee8 <forkret>
    80001144:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001146:	60bc                	ld	a5,64(s1)
    80001148:	6705                	lui	a4,0x1
    8000114a:	97ba                	add	a5,a5,a4
    8000114c:	f4bc                	sd	a5,104(s1)
}
    8000114e:	8526                	mv	a0,s1
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	addi	sp,sp,32
    8000115a:	8082                	ret
    freeproc(p);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f08080e7          	jalr	-248(ra) # 80001066 <freeproc>
    release(&p->lock);
    80001166:	8526                	mv	a0,s1
    80001168:	00005097          	auipc	ra,0x5
    8000116c:	138080e7          	jalr	312(ra) # 800062a0 <release>
    return 0;
    80001170:	84ca                	mv	s1,s2
    80001172:	bff1                	j	8000114e <allocproc+0x90>
    freeproc(p);
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	ef0080e7          	jalr	-272(ra) # 80001066 <freeproc>
    release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	120080e7          	jalr	288(ra) # 800062a0 <release>
    return 0;
    80001188:	84ca                	mv	s1,s2
    8000118a:	b7d1                	j	8000114e <allocproc+0x90>

000000008000118c <userinit>:
{
    8000118c:	1101                	addi	sp,sp,-32
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	e426                	sd	s1,8(sp)
    80001194:	1000                	addi	s0,sp,32
  p = allocproc();
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f28080e7          	jalr	-216(ra) # 800010be <allocproc>
    8000119e:	84aa                	mv	s1,a0
  initproc = p;
    800011a0:	00008797          	auipc	a5,0x8
    800011a4:	8ca7b023          	sd	a0,-1856(a5) # 80008a60 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a8:	03400613          	li	a2,52
    800011ac:	00008597          	auipc	a1,0x8
    800011b0:	86458593          	addi	a1,a1,-1948 # 80008a10 <initcode>
    800011b4:	6928                	ld	a0,80(a0)
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	672080e7          	jalr	1650(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    800011be:	6785                	lui	a5,0x1
    800011c0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c8:	6cb8                	ld	a4,88(s1)
    800011ca:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011cc:	4641                	li	a2,16
    800011ce:	00007597          	auipc	a1,0x7
    800011d2:	ff258593          	addi	a1,a1,-14 # 800081c0 <etext+0x1c0>
    800011d6:	15848513          	addi	a0,s1,344
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	0f0080e7          	jalr	240(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011e2:	00007517          	auipc	a0,0x7
    800011e6:	fee50513          	addi	a0,a0,-18 # 800081d0 <etext+0x1d0>
    800011ea:	00002097          	auipc	ra,0x2
    800011ee:	166080e7          	jalr	358(ra) # 80003350 <namei>
    800011f2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f6:	478d                	li	a5,3
    800011f8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	00005097          	auipc	ra,0x5
    80001200:	0a4080e7          	jalr	164(ra) # 800062a0 <release>
}
    80001204:	60e2                	ld	ra,24(sp)
    80001206:	6442                	ld	s0,16(sp)
    80001208:	64a2                	ld	s1,8(sp)
    8000120a:	6105                	addi	sp,sp,32
    8000120c:	8082                	ret

000000008000120e <growproc>:
{
    8000120e:	1101                	addi	sp,sp,-32
    80001210:	ec06                	sd	ra,24(sp)
    80001212:	e822                	sd	s0,16(sp)
    80001214:	e426                	sd	s1,8(sp)
    80001216:	e04a                	sd	s2,0(sp)
    80001218:	1000                	addi	s0,sp,32
    8000121a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	c94080e7          	jalr	-876(ra) # 80000eb0 <myproc>
    80001224:	84aa                	mv	s1,a0
  sz = p->sz;
    80001226:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001228:	01204c63          	bgtz	s2,80001240 <growproc+0x32>
  } else if(n < 0){
    8000122c:	02094663          	bltz	s2,80001258 <growproc+0x4a>
  p->sz = sz;
    80001230:	e4ac                	sd	a1,72(s1)
  return 0;
    80001232:	4501                	li	a0,0
}
    80001234:	60e2                	ld	ra,24(sp)
    80001236:	6442                	ld	s0,16(sp)
    80001238:	64a2                	ld	s1,8(sp)
    8000123a:	6902                	ld	s2,0(sp)
    8000123c:	6105                	addi	sp,sp,32
    8000123e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001240:	4691                	li	a3,4
    80001242:	00b90633          	add	a2,s2,a1
    80001246:	6928                	ld	a0,80(a0)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	69a080e7          	jalr	1690(ra) # 800008e2 <uvmalloc>
    80001250:	85aa                	mv	a1,a0
    80001252:	fd79                	bnez	a0,80001230 <growproc+0x22>
      return -1;
    80001254:	557d                	li	a0,-1
    80001256:	bff9                	j	80001234 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001258:	00b90633          	add	a2,s2,a1
    8000125c:	6928                	ld	a0,80(a0)
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	63c080e7          	jalr	1596(ra) # 8000089a <uvmdealloc>
    80001266:	85aa                	mv	a1,a0
    80001268:	b7e1                	j	80001230 <growproc+0x22>

000000008000126a <fork>:
{
    8000126a:	7179                	addi	sp,sp,-48
    8000126c:	f406                	sd	ra,40(sp)
    8000126e:	f022                	sd	s0,32(sp)
    80001270:	ec26                	sd	s1,24(sp)
    80001272:	e84a                	sd	s2,16(sp)
    80001274:	e44e                	sd	s3,8(sp)
    80001276:	e052                	sd	s4,0(sp)
    80001278:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	c36080e7          	jalr	-970(ra) # 80000eb0 <myproc>
    80001282:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001284:	00000097          	auipc	ra,0x0
    80001288:	e3a080e7          	jalr	-454(ra) # 800010be <allocproc>
    8000128c:	10050f63          	beqz	a0,800013aa <fork+0x140>
    80001290:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001292:	04893603          	ld	a2,72(s2)
    80001296:	692c                	ld	a1,80(a0)
    80001298:	05093503          	ld	a0,80(s2)
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	79a080e7          	jalr	1946(ra) # 80000a36 <uvmcopy>
    800012a4:	04054663          	bltz	a0,800012f0 <fork+0x86>
  np->sz = p->sz;
    800012a8:	04893783          	ld	a5,72(s2)
    800012ac:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b0:	05893683          	ld	a3,88(s2)
    800012b4:	87b6                	mv	a5,a3
    800012b6:	0589b703          	ld	a4,88(s3)
    800012ba:	12068693          	addi	a3,a3,288
    800012be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c2:	6788                	ld	a0,8(a5)
    800012c4:	6b8c                	ld	a1,16(a5)
    800012c6:	6f90                	ld	a2,24(a5)
    800012c8:	01073023          	sd	a6,0(a4)
    800012cc:	e708                	sd	a0,8(a4)
    800012ce:	eb0c                	sd	a1,16(a4)
    800012d0:	ef10                	sd	a2,24(a4)
    800012d2:	02078793          	addi	a5,a5,32
    800012d6:	02070713          	addi	a4,a4,32
    800012da:	fed792e3          	bne	a5,a3,800012be <fork+0x54>
  np->trapframe->a0 = 0;
    800012de:	0589b783          	ld	a5,88(s3)
    800012e2:	0607b823          	sd	zero,112(a5)
    800012e6:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012ea:	15000a13          	li	s4,336
    800012ee:	a03d                	j	8000131c <fork+0xb2>
    freeproc(np);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	d74080e7          	jalr	-652(ra) # 80001066 <freeproc>
    release(&np->lock);
    800012fa:	854e                	mv	a0,s3
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	fa4080e7          	jalr	-92(ra) # 800062a0 <release>
    return -1;
    80001304:	5a7d                	li	s4,-1
    80001306:	a849                	j	80001398 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001308:	00002097          	auipc	ra,0x2
    8000130c:	6de080e7          	jalr	1758(ra) # 800039e6 <filedup>
    80001310:	009987b3          	add	a5,s3,s1
    80001314:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001316:	04a1                	addi	s1,s1,8
    80001318:	01448763          	beq	s1,s4,80001326 <fork+0xbc>
    if(p->ofile[i])
    8000131c:	009907b3          	add	a5,s2,s1
    80001320:	6388                	ld	a0,0(a5)
    80001322:	f17d                	bnez	a0,80001308 <fork+0x9e>
    80001324:	bfcd                	j	80001316 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001326:	15093503          	ld	a0,336(s2)
    8000132a:	00002097          	auipc	ra,0x2
    8000132e:	842080e7          	jalr	-1982(ra) # 80002b6c <idup>
    80001332:	14a9b823          	sd	a0,336(s3)
  np->mask = p->mask;
    80001336:	03492783          	lw	a5,52(s2)
    8000133a:	02f9aa23          	sw	a5,52(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133e:	4641                	li	a2,16
    80001340:	15890593          	addi	a1,s2,344
    80001344:	15898513          	addi	a0,s3,344
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	f82080e7          	jalr	-126(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001350:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001354:	854e                	mv	a0,s3
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	f4a080e7          	jalr	-182(ra) # 800062a0 <release>
  acquire(&wait_lock);
    8000135e:	00007497          	auipc	s1,0x7
    80001362:	75a48493          	addi	s1,s1,1882 # 80008ab8 <wait_lock>
    80001366:	8526                	mv	a0,s1
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	e84080e7          	jalr	-380(ra) # 800061ec <acquire>
  np->parent = p;
    80001370:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001374:	8526                	mv	a0,s1
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	f2a080e7          	jalr	-214(ra) # 800062a0 <release>
  acquire(&np->lock);
    8000137e:	854e                	mv	a0,s3
    80001380:	00005097          	auipc	ra,0x5
    80001384:	e6c080e7          	jalr	-404(ra) # 800061ec <acquire>
  np->state = RUNNABLE;
    80001388:	478d                	li	a5,3
    8000138a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000138e:	854e                	mv	a0,s3
    80001390:	00005097          	auipc	ra,0x5
    80001394:	f10080e7          	jalr	-240(ra) # 800062a0 <release>
}
    80001398:	8552                	mv	a0,s4
    8000139a:	70a2                	ld	ra,40(sp)
    8000139c:	7402                	ld	s0,32(sp)
    8000139e:	64e2                	ld	s1,24(sp)
    800013a0:	6942                	ld	s2,16(sp)
    800013a2:	69a2                	ld	s3,8(sp)
    800013a4:	6a02                	ld	s4,0(sp)
    800013a6:	6145                	addi	sp,sp,48
    800013a8:	8082                	ret
    return -1;
    800013aa:	5a7d                	li	s4,-1
    800013ac:	b7f5                	j	80001398 <fork+0x12e>

00000000800013ae <scheduler>:
{
    800013ae:	7139                	addi	sp,sp,-64
    800013b0:	fc06                	sd	ra,56(sp)
    800013b2:	f822                	sd	s0,48(sp)
    800013b4:	f426                	sd	s1,40(sp)
    800013b6:	f04a                	sd	s2,32(sp)
    800013b8:	ec4e                	sd	s3,24(sp)
    800013ba:	e852                	sd	s4,16(sp)
    800013bc:	e456                	sd	s5,8(sp)
    800013be:	e05a                	sd	s6,0(sp)
    800013c0:	0080                	addi	s0,sp,64
    800013c2:	8792                	mv	a5,tp
  int id = r_tp();
    800013c4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c6:	00779a93          	slli	s5,a5,0x7
    800013ca:	00007717          	auipc	a4,0x7
    800013ce:	6d670713          	addi	a4,a4,1750 # 80008aa0 <pid_lock>
    800013d2:	9756                	add	a4,a4,s5
    800013d4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d8:	00007717          	auipc	a4,0x7
    800013dc:	70070713          	addi	a4,a4,1792 # 80008ad8 <cpus+0x8>
    800013e0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e2:	498d                	li	s3,3
        p->state = RUNNING;
    800013e4:	4b11                	li	s6,4
        c->proc = p;
    800013e6:	079e                	slli	a5,a5,0x7
    800013e8:	00007a17          	auipc	s4,0x7
    800013ec:	6b8a0a13          	addi	s4,s4,1720 # 80008aa0 <pid_lock>
    800013f0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	0000d917          	auipc	s2,0xd
    800013f6:	4de90913          	addi	s2,s2,1246 # 8000e8d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001402:	10079073          	csrw	sstatus,a5
    80001406:	00008497          	auipc	s1,0x8
    8000140a:	aca48493          	addi	s1,s1,-1334 # 80008ed0 <proc>
    8000140e:	a03d                	j	8000143c <scheduler+0x8e>
        p->state = RUNNING;
    80001410:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001414:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001418:	06048593          	addi	a1,s1,96
    8000141c:	8556                	mv	a0,s5
    8000141e:	00000097          	auipc	ra,0x0
    80001422:	6a4080e7          	jalr	1700(ra) # 80001ac2 <swtch>
        c->proc = 0;
    80001426:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	e74080e7          	jalr	-396(ra) # 800062a0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001434:	16848493          	addi	s1,s1,360
    80001438:	fd2481e3          	beq	s1,s2,800013fa <scheduler+0x4c>
      acquire(&p->lock);
    8000143c:	8526                	mv	a0,s1
    8000143e:	00005097          	auipc	ra,0x5
    80001442:	dae080e7          	jalr	-594(ra) # 800061ec <acquire>
      if(p->state == RUNNABLE) {
    80001446:	4c9c                	lw	a5,24(s1)
    80001448:	ff3791e3          	bne	a5,s3,8000142a <scheduler+0x7c>
    8000144c:	b7d1                	j	80001410 <scheduler+0x62>

000000008000144e <sched>:
{
    8000144e:	7179                	addi	sp,sp,-48
    80001450:	f406                	sd	ra,40(sp)
    80001452:	f022                	sd	s0,32(sp)
    80001454:	ec26                	sd	s1,24(sp)
    80001456:	e84a                	sd	s2,16(sp)
    80001458:	e44e                	sd	s3,8(sp)
    8000145a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	a54080e7          	jalr	-1452(ra) # 80000eb0 <myproc>
    80001464:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	d0c080e7          	jalr	-756(ra) # 80006172 <holding>
    8000146e:	c93d                	beqz	a0,800014e4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001470:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	00007717          	auipc	a4,0x7
    8000147a:	62a70713          	addi	a4,a4,1578 # 80008aa0 <pid_lock>
    8000147e:	97ba                	add	a5,a5,a4
    80001480:	0a87a703          	lw	a4,168(a5)
    80001484:	4785                	li	a5,1
    80001486:	06f71763          	bne	a4,a5,800014f4 <sched+0xa6>
  if(p->state == RUNNING)
    8000148a:	4c98                	lw	a4,24(s1)
    8000148c:	4791                	li	a5,4
    8000148e:	06f70b63          	beq	a4,a5,80001504 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001492:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001496:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001498:	efb5                	bnez	a5,80001514 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000149a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149c:	00007917          	auipc	s2,0x7
    800014a0:	60490913          	addi	s2,s2,1540 # 80008aa0 <pid_lock>
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	97ca                	add	a5,a5,s2
    800014aa:	0ac7a983          	lw	s3,172(a5)
    800014ae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b0:	2781                	sext.w	a5,a5
    800014b2:	079e                	slli	a5,a5,0x7
    800014b4:	00007597          	auipc	a1,0x7
    800014b8:	62458593          	addi	a1,a1,1572 # 80008ad8 <cpus+0x8>
    800014bc:	95be                	add	a1,a1,a5
    800014be:	06048513          	addi	a0,s1,96
    800014c2:	00000097          	auipc	ra,0x0
    800014c6:	600080e7          	jalr	1536(ra) # 80001ac2 <swtch>
    800014ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014cc:	2781                	sext.w	a5,a5
    800014ce:	079e                	slli	a5,a5,0x7
    800014d0:	97ca                	add	a5,a5,s2
    800014d2:	0b37a623          	sw	s3,172(a5)
}
    800014d6:	70a2                	ld	ra,40(sp)
    800014d8:	7402                	ld	s0,32(sp)
    800014da:	64e2                	ld	s1,24(sp)
    800014dc:	6942                	ld	s2,16(sp)
    800014de:	69a2                	ld	s3,8(sp)
    800014e0:	6145                	addi	sp,sp,48
    800014e2:	8082                	ret
    panic("sched p->lock");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	cf450513          	addi	a0,a0,-780 # 800081d8 <etext+0x1d8>
    800014ec:	00004097          	auipc	ra,0x4
    800014f0:	7b6080e7          	jalr	1974(ra) # 80005ca2 <panic>
    panic("sched locks");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	cf450513          	addi	a0,a0,-780 # 800081e8 <etext+0x1e8>
    800014fc:	00004097          	auipc	ra,0x4
    80001500:	7a6080e7          	jalr	1958(ra) # 80005ca2 <panic>
    panic("sched running");
    80001504:	00007517          	auipc	a0,0x7
    80001508:	cf450513          	addi	a0,a0,-780 # 800081f8 <etext+0x1f8>
    8000150c:	00004097          	auipc	ra,0x4
    80001510:	796080e7          	jalr	1942(ra) # 80005ca2 <panic>
    panic("sched interruptible");
    80001514:	00007517          	auipc	a0,0x7
    80001518:	cf450513          	addi	a0,a0,-780 # 80008208 <etext+0x208>
    8000151c:	00004097          	auipc	ra,0x4
    80001520:	786080e7          	jalr	1926(ra) # 80005ca2 <panic>

0000000080001524 <yield>:
{
    80001524:	1101                	addi	sp,sp,-32
    80001526:	ec06                	sd	ra,24(sp)
    80001528:	e822                	sd	s0,16(sp)
    8000152a:	e426                	sd	s1,8(sp)
    8000152c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	982080e7          	jalr	-1662(ra) # 80000eb0 <myproc>
    80001536:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	cb4080e7          	jalr	-844(ra) # 800061ec <acquire>
  p->state = RUNNABLE;
    80001540:	478d                	li	a5,3
    80001542:	cc9c                	sw	a5,24(s1)
  sched();
    80001544:	00000097          	auipc	ra,0x0
    80001548:	f0a080e7          	jalr	-246(ra) # 8000144e <sched>
  release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	d52080e7          	jalr	-686(ra) # 800062a0 <release>
}
    80001556:	60e2                	ld	ra,24(sp)
    80001558:	6442                	ld	s0,16(sp)
    8000155a:	64a2                	ld	s1,8(sp)
    8000155c:	6105                	addi	sp,sp,32
    8000155e:	8082                	ret

0000000080001560 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001560:	7179                	addi	sp,sp,-48
    80001562:	f406                	sd	ra,40(sp)
    80001564:	f022                	sd	s0,32(sp)
    80001566:	ec26                	sd	s1,24(sp)
    80001568:	e84a                	sd	s2,16(sp)
    8000156a:	e44e                	sd	s3,8(sp)
    8000156c:	1800                	addi	s0,sp,48
    8000156e:	89aa                	mv	s3,a0
    80001570:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001572:	00000097          	auipc	ra,0x0
    80001576:	93e080e7          	jalr	-1730(ra) # 80000eb0 <myproc>
    8000157a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	c70080e7          	jalr	-912(ra) # 800061ec <acquire>
  release(lk);
    80001584:	854a                	mv	a0,s2
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	d1a080e7          	jalr	-742(ra) # 800062a0 <release>

  // Go to sleep.
  p->chan = chan;
    8000158e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001592:	4789                	li	a5,2
    80001594:	cc9c                	sw	a5,24(s1)

  sched();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	eb8080e7          	jalr	-328(ra) # 8000144e <sched>

  // Tidy up.
  p->chan = 0;
    8000159e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a2:	8526                	mv	a0,s1
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	cfc080e7          	jalr	-772(ra) # 800062a0 <release>
  acquire(lk);
    800015ac:	854a                	mv	a0,s2
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	c3e080e7          	jalr	-962(ra) # 800061ec <acquire>
}
    800015b6:	70a2                	ld	ra,40(sp)
    800015b8:	7402                	ld	s0,32(sp)
    800015ba:	64e2                	ld	s1,24(sp)
    800015bc:	6942                	ld	s2,16(sp)
    800015be:	69a2                	ld	s3,8(sp)
    800015c0:	6145                	addi	sp,sp,48
    800015c2:	8082                	ret

00000000800015c4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015c4:	7139                	addi	sp,sp,-64
    800015c6:	fc06                	sd	ra,56(sp)
    800015c8:	f822                	sd	s0,48(sp)
    800015ca:	f426                	sd	s1,40(sp)
    800015cc:	f04a                	sd	s2,32(sp)
    800015ce:	ec4e                	sd	s3,24(sp)
    800015d0:	e852                	sd	s4,16(sp)
    800015d2:	e456                	sd	s5,8(sp)
    800015d4:	0080                	addi	s0,sp,64
    800015d6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015d8:	00008497          	auipc	s1,0x8
    800015dc:	8f848493          	addi	s1,s1,-1800 # 80008ed0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015e0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015e2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015e4:	0000d917          	auipc	s2,0xd
    800015e8:	2ec90913          	addi	s2,s2,748 # 8000e8d0 <tickslock>
    800015ec:	a821                	j	80001604 <wakeup+0x40>
        p->state = RUNNABLE;
    800015ee:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	cac080e7          	jalr	-852(ra) # 800062a0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	16848493          	addi	s1,s1,360
    80001600:	03248463          	beq	s1,s2,80001628 <wakeup+0x64>
    if(p != myproc()){
    80001604:	00000097          	auipc	ra,0x0
    80001608:	8ac080e7          	jalr	-1876(ra) # 80000eb0 <myproc>
    8000160c:	fea488e3          	beq	s1,a0,800015fc <wakeup+0x38>
      acquire(&p->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	bda080e7          	jalr	-1062(ra) # 800061ec <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000161a:	4c9c                	lw	a5,24(s1)
    8000161c:	fd379be3          	bne	a5,s3,800015f2 <wakeup+0x2e>
    80001620:	709c                	ld	a5,32(s1)
    80001622:	fd4798e3          	bne	a5,s4,800015f2 <wakeup+0x2e>
    80001626:	b7e1                	j	800015ee <wakeup+0x2a>
    }
  }
}
    80001628:	70e2                	ld	ra,56(sp)
    8000162a:	7442                	ld	s0,48(sp)
    8000162c:	74a2                	ld	s1,40(sp)
    8000162e:	7902                	ld	s2,32(sp)
    80001630:	69e2                	ld	s3,24(sp)
    80001632:	6a42                	ld	s4,16(sp)
    80001634:	6aa2                	ld	s5,8(sp)
    80001636:	6121                	addi	sp,sp,64
    80001638:	8082                	ret

000000008000163a <reparent>:
{
    8000163a:	7179                	addi	sp,sp,-48
    8000163c:	f406                	sd	ra,40(sp)
    8000163e:	f022                	sd	s0,32(sp)
    80001640:	ec26                	sd	s1,24(sp)
    80001642:	e84a                	sd	s2,16(sp)
    80001644:	e44e                	sd	s3,8(sp)
    80001646:	e052                	sd	s4,0(sp)
    80001648:	1800                	addi	s0,sp,48
    8000164a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164c:	00008497          	auipc	s1,0x8
    80001650:	88448493          	addi	s1,s1,-1916 # 80008ed0 <proc>
      pp->parent = initproc;
    80001654:	00007a17          	auipc	s4,0x7
    80001658:	40ca0a13          	addi	s4,s4,1036 # 80008a60 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000165c:	0000d997          	auipc	s3,0xd
    80001660:	27498993          	addi	s3,s3,628 # 8000e8d0 <tickslock>
    80001664:	a029                	j	8000166e <reparent+0x34>
    80001666:	16848493          	addi	s1,s1,360
    8000166a:	01348d63          	beq	s1,s3,80001684 <reparent+0x4a>
    if(pp->parent == p){
    8000166e:	7c9c                	ld	a5,56(s1)
    80001670:	ff279be3          	bne	a5,s2,80001666 <reparent+0x2c>
      pp->parent = initproc;
    80001674:	000a3503          	ld	a0,0(s4)
    80001678:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	f4a080e7          	jalr	-182(ra) # 800015c4 <wakeup>
    80001682:	b7d5                	j	80001666 <reparent+0x2c>
}
    80001684:	70a2                	ld	ra,40(sp)
    80001686:	7402                	ld	s0,32(sp)
    80001688:	64e2                	ld	s1,24(sp)
    8000168a:	6942                	ld	s2,16(sp)
    8000168c:	69a2                	ld	s3,8(sp)
    8000168e:	6a02                	ld	s4,0(sp)
    80001690:	6145                	addi	sp,sp,48
    80001692:	8082                	ret

0000000080001694 <exit>:
{
    80001694:	7179                	addi	sp,sp,-48
    80001696:	f406                	sd	ra,40(sp)
    80001698:	f022                	sd	s0,32(sp)
    8000169a:	ec26                	sd	s1,24(sp)
    8000169c:	e84a                	sd	s2,16(sp)
    8000169e:	e44e                	sd	s3,8(sp)
    800016a0:	e052                	sd	s4,0(sp)
    800016a2:	1800                	addi	s0,sp,48
    800016a4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	80a080e7          	jalr	-2038(ra) # 80000eb0 <myproc>
    800016ae:	89aa                	mv	s3,a0
  if(p == initproc)
    800016b0:	00007797          	auipc	a5,0x7
    800016b4:	3b07b783          	ld	a5,944(a5) # 80008a60 <initproc>
    800016b8:	0d050493          	addi	s1,a0,208
    800016bc:	15050913          	addi	s2,a0,336
    800016c0:	02a79363          	bne	a5,a0,800016e6 <exit+0x52>
    panic("init exiting");
    800016c4:	00007517          	auipc	a0,0x7
    800016c8:	b5c50513          	addi	a0,a0,-1188 # 80008220 <etext+0x220>
    800016cc:	00004097          	auipc	ra,0x4
    800016d0:	5d6080e7          	jalr	1494(ra) # 80005ca2 <panic>
      fileclose(f);
    800016d4:	00002097          	auipc	ra,0x2
    800016d8:	364080e7          	jalr	868(ra) # 80003a38 <fileclose>
      p->ofile[fd] = 0;
    800016dc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016e0:	04a1                	addi	s1,s1,8
    800016e2:	01248563          	beq	s1,s2,800016ec <exit+0x58>
    if(p->ofile[fd]){
    800016e6:	6088                	ld	a0,0(s1)
    800016e8:	f575                	bnez	a0,800016d4 <exit+0x40>
    800016ea:	bfdd                	j	800016e0 <exit+0x4c>
  begin_op();
    800016ec:	00002097          	auipc	ra,0x2
    800016f0:	e80080e7          	jalr	-384(ra) # 8000356c <begin_op>
  iput(p->cwd);
    800016f4:	1509b503          	ld	a0,336(s3)
    800016f8:	00001097          	auipc	ra,0x1
    800016fc:	66c080e7          	jalr	1644(ra) # 80002d64 <iput>
  end_op();
    80001700:	00002097          	auipc	ra,0x2
    80001704:	eec080e7          	jalr	-276(ra) # 800035ec <end_op>
  p->cwd = 0;
    80001708:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000170c:	00007497          	auipc	s1,0x7
    80001710:	3ac48493          	addi	s1,s1,940 # 80008ab8 <wait_lock>
    80001714:	8526                	mv	a0,s1
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	ad6080e7          	jalr	-1322(ra) # 800061ec <acquire>
  reparent(p);
    8000171e:	854e                	mv	a0,s3
    80001720:	00000097          	auipc	ra,0x0
    80001724:	f1a080e7          	jalr	-230(ra) # 8000163a <reparent>
  wakeup(p->parent);
    80001728:	0389b503          	ld	a0,56(s3)
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	e98080e7          	jalr	-360(ra) # 800015c4 <wakeup>
  acquire(&p->lock);
    80001734:	854e                	mv	a0,s3
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	ab6080e7          	jalr	-1354(ra) # 800061ec <acquire>
  p->xstate = status;
    8000173e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001742:	4795                	li	a5,5
    80001744:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	b56080e7          	jalr	-1194(ra) # 800062a0 <release>
  sched();
    80001752:	00000097          	auipc	ra,0x0
    80001756:	cfc080e7          	jalr	-772(ra) # 8000144e <sched>
  panic("zombie exit");
    8000175a:	00007517          	auipc	a0,0x7
    8000175e:	ad650513          	addi	a0,a0,-1322 # 80008230 <etext+0x230>
    80001762:	00004097          	auipc	ra,0x4
    80001766:	540080e7          	jalr	1344(ra) # 80005ca2 <panic>

000000008000176a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000176a:	7179                	addi	sp,sp,-48
    8000176c:	f406                	sd	ra,40(sp)
    8000176e:	f022                	sd	s0,32(sp)
    80001770:	ec26                	sd	s1,24(sp)
    80001772:	e84a                	sd	s2,16(sp)
    80001774:	e44e                	sd	s3,8(sp)
    80001776:	1800                	addi	s0,sp,48
    80001778:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000177a:	00007497          	auipc	s1,0x7
    8000177e:	75648493          	addi	s1,s1,1878 # 80008ed0 <proc>
    80001782:	0000d997          	auipc	s3,0xd
    80001786:	14e98993          	addi	s3,s3,334 # 8000e8d0 <tickslock>
    acquire(&p->lock);
    8000178a:	8526                	mv	a0,s1
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	a60080e7          	jalr	-1440(ra) # 800061ec <acquire>
    if(p->pid == pid){
    80001794:	589c                	lw	a5,48(s1)
    80001796:	01278d63          	beq	a5,s2,800017b0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	b04080e7          	jalr	-1276(ra) # 800062a0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017a4:	16848493          	addi	s1,s1,360
    800017a8:	ff3491e3          	bne	s1,s3,8000178a <kill+0x20>
  }
  return -1;
    800017ac:	557d                	li	a0,-1
    800017ae:	a829                	j	800017c8 <kill+0x5e>
      p->killed = 1;
    800017b0:	4785                	li	a5,1
    800017b2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017b4:	4c98                	lw	a4,24(s1)
    800017b6:	4789                	li	a5,2
    800017b8:	00f70f63          	beq	a4,a5,800017d6 <kill+0x6c>
      release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	ae2080e7          	jalr	-1310(ra) # 800062a0 <release>
      return 0;
    800017c6:	4501                	li	a0,0
}
    800017c8:	70a2                	ld	ra,40(sp)
    800017ca:	7402                	ld	s0,32(sp)
    800017cc:	64e2                	ld	s1,24(sp)
    800017ce:	6942                	ld	s2,16(sp)
    800017d0:	69a2                	ld	s3,8(sp)
    800017d2:	6145                	addi	sp,sp,48
    800017d4:	8082                	ret
        p->state = RUNNABLE;
    800017d6:	478d                	li	a5,3
    800017d8:	cc9c                	sw	a5,24(s1)
    800017da:	b7cd                	j	800017bc <kill+0x52>

00000000800017dc <setkilled>:

void
setkilled(struct proc *p)
{
    800017dc:	1101                	addi	sp,sp,-32
    800017de:	ec06                	sd	ra,24(sp)
    800017e0:	e822                	sd	s0,16(sp)
    800017e2:	e426                	sd	s1,8(sp)
    800017e4:	1000                	addi	s0,sp,32
    800017e6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	a04080e7          	jalr	-1532(ra) # 800061ec <acquire>
  p->killed = 1;
    800017f0:	4785                	li	a5,1
    800017f2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017f4:	8526                	mv	a0,s1
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	aaa080e7          	jalr	-1366(ra) # 800062a0 <release>
}
    800017fe:	60e2                	ld	ra,24(sp)
    80001800:	6442                	ld	s0,16(sp)
    80001802:	64a2                	ld	s1,8(sp)
    80001804:	6105                	addi	sp,sp,32
    80001806:	8082                	ret

0000000080001808 <killed>:

int
killed(struct proc *p)
{
    80001808:	1101                	addi	sp,sp,-32
    8000180a:	ec06                	sd	ra,24(sp)
    8000180c:	e822                	sd	s0,16(sp)
    8000180e:	e426                	sd	s1,8(sp)
    80001810:	e04a                	sd	s2,0(sp)
    80001812:	1000                	addi	s0,sp,32
    80001814:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	9d6080e7          	jalr	-1578(ra) # 800061ec <acquire>
  k = p->killed;
    8000181e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001822:	8526                	mv	a0,s1
    80001824:	00005097          	auipc	ra,0x5
    80001828:	a7c080e7          	jalr	-1412(ra) # 800062a0 <release>
  return k;
}
    8000182c:	854a                	mv	a0,s2
    8000182e:	60e2                	ld	ra,24(sp)
    80001830:	6442                	ld	s0,16(sp)
    80001832:	64a2                	ld	s1,8(sp)
    80001834:	6902                	ld	s2,0(sp)
    80001836:	6105                	addi	sp,sp,32
    80001838:	8082                	ret

000000008000183a <wait>:
{
    8000183a:	715d                	addi	sp,sp,-80
    8000183c:	e486                	sd	ra,72(sp)
    8000183e:	e0a2                	sd	s0,64(sp)
    80001840:	fc26                	sd	s1,56(sp)
    80001842:	f84a                	sd	s2,48(sp)
    80001844:	f44e                	sd	s3,40(sp)
    80001846:	f052                	sd	s4,32(sp)
    80001848:	ec56                	sd	s5,24(sp)
    8000184a:	e85a                	sd	s6,16(sp)
    8000184c:	e45e                	sd	s7,8(sp)
    8000184e:	e062                	sd	s8,0(sp)
    80001850:	0880                	addi	s0,sp,80
    80001852:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001854:	fffff097          	auipc	ra,0xfffff
    80001858:	65c080e7          	jalr	1628(ra) # 80000eb0 <myproc>
    8000185c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	25a50513          	addi	a0,a0,602 # 80008ab8 <wait_lock>
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	986080e7          	jalr	-1658(ra) # 800061ec <acquire>
    havekids = 0;
    8000186e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001870:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001872:	0000d997          	auipc	s3,0xd
    80001876:	05e98993          	addi	s3,s3,94 # 8000e8d0 <tickslock>
        havekids = 1;
    8000187a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000187c:	00007c17          	auipc	s8,0x7
    80001880:	23cc0c13          	addi	s8,s8,572 # 80008ab8 <wait_lock>
    havekids = 0;
    80001884:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001886:	00007497          	auipc	s1,0x7
    8000188a:	64a48493          	addi	s1,s1,1610 # 80008ed0 <proc>
    8000188e:	a0bd                	j	800018fc <wait+0xc2>
          pid = pp->pid;
    80001890:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001894:	000b0e63          	beqz	s6,800018b0 <wait+0x76>
    80001898:	4691                	li	a3,4
    8000189a:	02c48613          	addi	a2,s1,44
    8000189e:	85da                	mv	a1,s6
    800018a0:	05093503          	ld	a0,80(s2)
    800018a4:	fffff097          	auipc	ra,0xfffff
    800018a8:	296080e7          	jalr	662(ra) # 80000b3a <copyout>
    800018ac:	02054563          	bltz	a0,800018d6 <wait+0x9c>
          freeproc(pp);
    800018b0:	8526                	mv	a0,s1
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	7b4080e7          	jalr	1972(ra) # 80001066 <freeproc>
          release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	9e4080e7          	jalr	-1564(ra) # 800062a0 <release>
          release(&wait_lock);
    800018c4:	00007517          	auipc	a0,0x7
    800018c8:	1f450513          	addi	a0,a0,500 # 80008ab8 <wait_lock>
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	9d4080e7          	jalr	-1580(ra) # 800062a0 <release>
          return pid;
    800018d4:	a0b5                	j	80001940 <wait+0x106>
            release(&pp->lock);
    800018d6:	8526                	mv	a0,s1
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	9c8080e7          	jalr	-1592(ra) # 800062a0 <release>
            release(&wait_lock);
    800018e0:	00007517          	auipc	a0,0x7
    800018e4:	1d850513          	addi	a0,a0,472 # 80008ab8 <wait_lock>
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	9b8080e7          	jalr	-1608(ra) # 800062a0 <release>
            return -1;
    800018f0:	59fd                	li	s3,-1
    800018f2:	a0b9                	j	80001940 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	16848493          	addi	s1,s1,360
    800018f8:	03348463          	beq	s1,s3,80001920 <wait+0xe6>
      if(pp->parent == p){
    800018fc:	7c9c                	ld	a5,56(s1)
    800018fe:	ff279be3          	bne	a5,s2,800018f4 <wait+0xba>
        acquire(&pp->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	8e8080e7          	jalr	-1816(ra) # 800061ec <acquire>
        if(pp->state == ZOMBIE){
    8000190c:	4c9c                	lw	a5,24(s1)
    8000190e:	f94781e3          	beq	a5,s4,80001890 <wait+0x56>
        release(&pp->lock);
    80001912:	8526                	mv	a0,s1
    80001914:	00005097          	auipc	ra,0x5
    80001918:	98c080e7          	jalr	-1652(ra) # 800062a0 <release>
        havekids = 1;
    8000191c:	8756                	mv	a4,s5
    8000191e:	bfd9                	j	800018f4 <wait+0xba>
    if(!havekids || killed(p)){
    80001920:	c719                	beqz	a4,8000192e <wait+0xf4>
    80001922:	854a                	mv	a0,s2
    80001924:	00000097          	auipc	ra,0x0
    80001928:	ee4080e7          	jalr	-284(ra) # 80001808 <killed>
    8000192c:	c51d                	beqz	a0,8000195a <wait+0x120>
      release(&wait_lock);
    8000192e:	00007517          	auipc	a0,0x7
    80001932:	18a50513          	addi	a0,a0,394 # 80008ab8 <wait_lock>
    80001936:	00005097          	auipc	ra,0x5
    8000193a:	96a080e7          	jalr	-1686(ra) # 800062a0 <release>
      return -1;
    8000193e:	59fd                	li	s3,-1
}
    80001940:	854e                	mv	a0,s3
    80001942:	60a6                	ld	ra,72(sp)
    80001944:	6406                	ld	s0,64(sp)
    80001946:	74e2                	ld	s1,56(sp)
    80001948:	7942                	ld	s2,48(sp)
    8000194a:	79a2                	ld	s3,40(sp)
    8000194c:	7a02                	ld	s4,32(sp)
    8000194e:	6ae2                	ld	s5,24(sp)
    80001950:	6b42                	ld	s6,16(sp)
    80001952:	6ba2                	ld	s7,8(sp)
    80001954:	6c02                	ld	s8,0(sp)
    80001956:	6161                	addi	sp,sp,80
    80001958:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000195a:	85e2                	mv	a1,s8
    8000195c:	854a                	mv	a0,s2
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	c02080e7          	jalr	-1022(ra) # 80001560 <sleep>
    havekids = 0;
    80001966:	bf39                	j	80001884 <wait+0x4a>

0000000080001968 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001968:	7179                	addi	sp,sp,-48
    8000196a:	f406                	sd	ra,40(sp)
    8000196c:	f022                	sd	s0,32(sp)
    8000196e:	ec26                	sd	s1,24(sp)
    80001970:	e84a                	sd	s2,16(sp)
    80001972:	e44e                	sd	s3,8(sp)
    80001974:	e052                	sd	s4,0(sp)
    80001976:	1800                	addi	s0,sp,48
    80001978:	84aa                	mv	s1,a0
    8000197a:	892e                	mv	s2,a1
    8000197c:	89b2                	mv	s3,a2
    8000197e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	530080e7          	jalr	1328(ra) # 80000eb0 <myproc>
  if(user_dst){
    80001988:	c08d                	beqz	s1,800019aa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000198a:	86d2                	mv	a3,s4
    8000198c:	864e                	mv	a2,s3
    8000198e:	85ca                	mv	a1,s2
    80001990:	6928                	ld	a0,80(a0)
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	1a8080e7          	jalr	424(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000199a:	70a2                	ld	ra,40(sp)
    8000199c:	7402                	ld	s0,32(sp)
    8000199e:	64e2                	ld	s1,24(sp)
    800019a0:	6942                	ld	s2,16(sp)
    800019a2:	69a2                	ld	s3,8(sp)
    800019a4:	6a02                	ld	s4,0(sp)
    800019a6:	6145                	addi	sp,sp,48
    800019a8:	8082                	ret
    memmove((char *)dst, src, len);
    800019aa:	000a061b          	sext.w	a2,s4
    800019ae:	85ce                	mv	a1,s3
    800019b0:	854a                	mv	a0,s2
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	826080e7          	jalr	-2010(ra) # 800001d8 <memmove>
    return 0;
    800019ba:	8526                	mv	a0,s1
    800019bc:	bff9                	j	8000199a <either_copyout+0x32>

00000000800019be <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019be:	7179                	addi	sp,sp,-48
    800019c0:	f406                	sd	ra,40(sp)
    800019c2:	f022                	sd	s0,32(sp)
    800019c4:	ec26                	sd	s1,24(sp)
    800019c6:	e84a                	sd	s2,16(sp)
    800019c8:	e44e                	sd	s3,8(sp)
    800019ca:	e052                	sd	s4,0(sp)
    800019cc:	1800                	addi	s0,sp,48
    800019ce:	892a                	mv	s2,a0
    800019d0:	84ae                	mv	s1,a1
    800019d2:	89b2                	mv	s3,a2
    800019d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	4da080e7          	jalr	1242(ra) # 80000eb0 <myproc>
  if(user_src){
    800019de:	c08d                	beqz	s1,80001a00 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019e0:	86d2                	mv	a3,s4
    800019e2:	864e                	mv	a2,s3
    800019e4:	85ca                	mv	a1,s2
    800019e6:	6928                	ld	a0,80(a0)
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	212080e7          	jalr	530(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019f0:	70a2                	ld	ra,40(sp)
    800019f2:	7402                	ld	s0,32(sp)
    800019f4:	64e2                	ld	s1,24(sp)
    800019f6:	6942                	ld	s2,16(sp)
    800019f8:	69a2                	ld	s3,8(sp)
    800019fa:	6a02                	ld	s4,0(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a00:	000a061b          	sext.w	a2,s4
    80001a04:	85ce                	mv	a1,s3
    80001a06:	854a                	mv	a0,s2
    80001a08:	ffffe097          	auipc	ra,0xffffe
    80001a0c:	7d0080e7          	jalr	2000(ra) # 800001d8 <memmove>
    return 0;
    80001a10:	8526                	mv	a0,s1
    80001a12:	bff9                	j	800019f0 <either_copyin+0x32>

0000000080001a14 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a14:	715d                	addi	sp,sp,-80
    80001a16:	e486                	sd	ra,72(sp)
    80001a18:	e0a2                	sd	s0,64(sp)
    80001a1a:	fc26                	sd	s1,56(sp)
    80001a1c:	f84a                	sd	s2,48(sp)
    80001a1e:	f44e                	sd	s3,40(sp)
    80001a20:	f052                	sd	s4,32(sp)
    80001a22:	ec56                	sd	s5,24(sp)
    80001a24:	e85a                	sd	s6,16(sp)
    80001a26:	e45e                	sd	s7,8(sp)
    80001a28:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a2a:	00006517          	auipc	a0,0x6
    80001a2e:	61e50513          	addi	a0,a0,1566 # 80008048 <etext+0x48>
    80001a32:	00004097          	auipc	ra,0x4
    80001a36:	2ba080e7          	jalr	698(ra) # 80005cec <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3a:	00007497          	auipc	s1,0x7
    80001a3e:	5ee48493          	addi	s1,s1,1518 # 80009028 <proc+0x158>
    80001a42:	0000d917          	auipc	s2,0xd
    80001a46:	fe690913          	addi	s2,s2,-26 # 8000ea28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a4a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a4c:	00006997          	auipc	s3,0x6
    80001a50:	7f498993          	addi	s3,s3,2036 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a54:	00006a97          	auipc	s5,0x6
    80001a58:	7f4a8a93          	addi	s5,s5,2036 # 80008248 <etext+0x248>
    printf("\n");
    80001a5c:	00006a17          	auipc	s4,0x6
    80001a60:	5eca0a13          	addi	s4,s4,1516 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a64:	00007b97          	auipc	s7,0x7
    80001a68:	824b8b93          	addi	s7,s7,-2012 # 80008288 <states.1723>
    80001a6c:	a00d                	j	80001a8e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6e:	ed86a583          	lw	a1,-296(a3)
    80001a72:	8556                	mv	a0,s5
    80001a74:	00004097          	auipc	ra,0x4
    80001a78:	278080e7          	jalr	632(ra) # 80005cec <printf>
    printf("\n");
    80001a7c:	8552                	mv	a0,s4
    80001a7e:	00004097          	auipc	ra,0x4
    80001a82:	26e080e7          	jalr	622(ra) # 80005cec <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a86:	16848493          	addi	s1,s1,360
    80001a8a:	03248163          	beq	s1,s2,80001aac <procdump+0x98>
    if(p->state == UNUSED)
    80001a8e:	86a6                	mv	a3,s1
    80001a90:	ec04a783          	lw	a5,-320(s1)
    80001a94:	dbed                	beqz	a5,80001a86 <procdump+0x72>
      state = "???";
    80001a96:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a98:	fcfb6be3          	bltu	s6,a5,80001a6e <procdump+0x5a>
    80001a9c:	1782                	slli	a5,a5,0x20
    80001a9e:	9381                	srli	a5,a5,0x20
    80001aa0:	078e                	slli	a5,a5,0x3
    80001aa2:	97de                	add	a5,a5,s7
    80001aa4:	6390                	ld	a2,0(a5)
    80001aa6:	f661                	bnez	a2,80001a6e <procdump+0x5a>
      state = "???";
    80001aa8:	864e                	mv	a2,s3
    80001aaa:	b7d1                	j	80001a6e <procdump+0x5a>
  }
}
    80001aac:	60a6                	ld	ra,72(sp)
    80001aae:	6406                	ld	s0,64(sp)
    80001ab0:	74e2                	ld	s1,56(sp)
    80001ab2:	7942                	ld	s2,48(sp)
    80001ab4:	79a2                	ld	s3,40(sp)
    80001ab6:	7a02                	ld	s4,32(sp)
    80001ab8:	6ae2                	ld	s5,24(sp)
    80001aba:	6b42                	ld	s6,16(sp)
    80001abc:	6ba2                	ld	s7,8(sp)
    80001abe:	6161                	addi	sp,sp,80
    80001ac0:	8082                	ret

0000000080001ac2 <swtch>:
    80001ac2:	00153023          	sd	ra,0(a0)
    80001ac6:	00253423          	sd	sp,8(a0)
    80001aca:	e900                	sd	s0,16(a0)
    80001acc:	ed04                	sd	s1,24(a0)
    80001ace:	03253023          	sd	s2,32(a0)
    80001ad2:	03353423          	sd	s3,40(a0)
    80001ad6:	03453823          	sd	s4,48(a0)
    80001ada:	03553c23          	sd	s5,56(a0)
    80001ade:	05653023          	sd	s6,64(a0)
    80001ae2:	05753423          	sd	s7,72(a0)
    80001ae6:	05853823          	sd	s8,80(a0)
    80001aea:	05953c23          	sd	s9,88(a0)
    80001aee:	07a53023          	sd	s10,96(a0)
    80001af2:	07b53423          	sd	s11,104(a0)
    80001af6:	0005b083          	ld	ra,0(a1)
    80001afa:	0085b103          	ld	sp,8(a1)
    80001afe:	6980                	ld	s0,16(a1)
    80001b00:	6d84                	ld	s1,24(a1)
    80001b02:	0205b903          	ld	s2,32(a1)
    80001b06:	0285b983          	ld	s3,40(a1)
    80001b0a:	0305ba03          	ld	s4,48(a1)
    80001b0e:	0385ba83          	ld	s5,56(a1)
    80001b12:	0405bb03          	ld	s6,64(a1)
    80001b16:	0485bb83          	ld	s7,72(a1)
    80001b1a:	0505bc03          	ld	s8,80(a1)
    80001b1e:	0585bc83          	ld	s9,88(a1)
    80001b22:	0605bd03          	ld	s10,96(a1)
    80001b26:	0685bd83          	ld	s11,104(a1)
    80001b2a:	8082                	ret

0000000080001b2c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b2c:	1141                	addi	sp,sp,-16
    80001b2e:	e406                	sd	ra,8(sp)
    80001b30:	e022                	sd	s0,0(sp)
    80001b32:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b34:	00006597          	auipc	a1,0x6
    80001b38:	78458593          	addi	a1,a1,1924 # 800082b8 <states.1723+0x30>
    80001b3c:	0000d517          	auipc	a0,0xd
    80001b40:	d9450513          	addi	a0,a0,-620 # 8000e8d0 <tickslock>
    80001b44:	00004097          	auipc	ra,0x4
    80001b48:	618080e7          	jalr	1560(ra) # 8000615c <initlock>
}
    80001b4c:	60a2                	ld	ra,8(sp)
    80001b4e:	6402                	ld	s0,0(sp)
    80001b50:	0141                	addi	sp,sp,16
    80001b52:	8082                	ret

0000000080001b54 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b54:	1141                	addi	sp,sp,-16
    80001b56:	e422                	sd	s0,8(sp)
    80001b58:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b5a:	00003797          	auipc	a5,0x3
    80001b5e:	51678793          	addi	a5,a5,1302 # 80005070 <kernelvec>
    80001b62:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b66:	6422                	ld	s0,8(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret

0000000080001b6c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b6c:	1141                	addi	sp,sp,-16
    80001b6e:	e406                	sd	ra,8(sp)
    80001b70:	e022                	sd	s0,0(sp)
    80001b72:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	33c080e7          	jalr	828(ra) # 80000eb0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b82:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b86:	00005617          	auipc	a2,0x5
    80001b8a:	47a60613          	addi	a2,a2,1146 # 80007000 <_trampoline>
    80001b8e:	00005697          	auipc	a3,0x5
    80001b92:	47268693          	addi	a3,a3,1138 # 80007000 <_trampoline>
    80001b96:	8e91                	sub	a3,a3,a2
    80001b98:	040007b7          	lui	a5,0x4000
    80001b9c:	17fd                	addi	a5,a5,-1
    80001b9e:	07b2                	slli	a5,a5,0xc
    80001ba0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba2:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba8:	180026f3          	csrr	a3,satp
    80001bac:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bae:	6d38                	ld	a4,88(a0)
    80001bb0:	6134                	ld	a3,64(a0)
    80001bb2:	6585                	lui	a1,0x1
    80001bb4:	96ae                	add	a3,a3,a1
    80001bb6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb8:	6d38                	ld	a4,88(a0)
    80001bba:	00000697          	auipc	a3,0x0
    80001bbe:	13068693          	addi	a3,a3,304 # 80001cea <usertrap>
    80001bc2:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc6:	8692                	mv	a3,tp
    80001bc8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bca:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bce:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bd2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bda:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bdc:	6f18                	ld	a4,24(a4)
    80001bde:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001be2:	6928                	ld	a0,80(a0)
    80001be4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001be6:	00005717          	auipc	a4,0x5
    80001bea:	4b670713          	addi	a4,a4,1206 # 8000709c <userret>
    80001bee:	8f11                	sub	a4,a4,a2
    80001bf0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bf2:	577d                	li	a4,-1
    80001bf4:	177e                	slli	a4,a4,0x3f
    80001bf6:	8d59                	or	a0,a0,a4
    80001bf8:	9782                	jalr	a5
}
    80001bfa:	60a2                	ld	ra,8(sp)
    80001bfc:	6402                	ld	s0,0(sp)
    80001bfe:	0141                	addi	sp,sp,16
    80001c00:	8082                	ret

0000000080001c02 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c02:	1101                	addi	sp,sp,-32
    80001c04:	ec06                	sd	ra,24(sp)
    80001c06:	e822                	sd	s0,16(sp)
    80001c08:	e426                	sd	s1,8(sp)
    80001c0a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c0c:	0000d497          	auipc	s1,0xd
    80001c10:	cc448493          	addi	s1,s1,-828 # 8000e8d0 <tickslock>
    80001c14:	8526                	mv	a0,s1
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	5d6080e7          	jalr	1494(ra) # 800061ec <acquire>
  ticks++;
    80001c1e:	00007517          	auipc	a0,0x7
    80001c22:	e4a50513          	addi	a0,a0,-438 # 80008a68 <ticks>
    80001c26:	411c                	lw	a5,0(a0)
    80001c28:	2785                	addiw	a5,a5,1
    80001c2a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c2c:	00000097          	auipc	ra,0x0
    80001c30:	998080e7          	jalr	-1640(ra) # 800015c4 <wakeup>
  release(&tickslock);
    80001c34:	8526                	mv	a0,s1
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	66a080e7          	jalr	1642(ra) # 800062a0 <release>
}
    80001c3e:	60e2                	ld	ra,24(sp)
    80001c40:	6442                	ld	s0,16(sp)
    80001c42:	64a2                	ld	s1,8(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret

0000000080001c48 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c48:	1101                	addi	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c52:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c56:	00074d63          	bltz	a4,80001c70 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c5a:	57fd                	li	a5,-1
    80001c5c:	17fe                	slli	a5,a5,0x3f
    80001c5e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c60:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c62:	06f70363          	beq	a4,a5,80001cc8 <devintr+0x80>
  }
}
    80001c66:	60e2                	ld	ra,24(sp)
    80001c68:	6442                	ld	s0,16(sp)
    80001c6a:	64a2                	ld	s1,8(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret
     (scause & 0xff) == 9){
    80001c70:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c74:	46a5                	li	a3,9
    80001c76:	fed792e3          	bne	a5,a3,80001c5a <devintr+0x12>
    int irq = plic_claim();
    80001c7a:	00003097          	auipc	ra,0x3
    80001c7e:	4fe080e7          	jalr	1278(ra) # 80005178 <plic_claim>
    80001c82:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c84:	47a9                	li	a5,10
    80001c86:	02f50763          	beq	a0,a5,80001cb4 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c8a:	4785                	li	a5,1
    80001c8c:	02f50963          	beq	a0,a5,80001cbe <devintr+0x76>
    return 1;
    80001c90:	4505                	li	a0,1
    } else if(irq){
    80001c92:	d8f1                	beqz	s1,80001c66 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c94:	85a6                	mv	a1,s1
    80001c96:	00006517          	auipc	a0,0x6
    80001c9a:	62a50513          	addi	a0,a0,1578 # 800082c0 <states.1723+0x38>
    80001c9e:	00004097          	auipc	ra,0x4
    80001ca2:	04e080e7          	jalr	78(ra) # 80005cec <printf>
      plic_complete(irq);
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	00003097          	auipc	ra,0x3
    80001cac:	4f4080e7          	jalr	1268(ra) # 8000519c <plic_complete>
    return 1;
    80001cb0:	4505                	li	a0,1
    80001cb2:	bf55                	j	80001c66 <devintr+0x1e>
      uartintr();
    80001cb4:	00004097          	auipc	ra,0x4
    80001cb8:	458080e7          	jalr	1112(ra) # 8000610c <uartintr>
    80001cbc:	b7ed                	j	80001ca6 <devintr+0x5e>
      virtio_disk_intr();
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	a08080e7          	jalr	-1528(ra) # 800056c6 <virtio_disk_intr>
    80001cc6:	b7c5                	j	80001ca6 <devintr+0x5e>
    if(cpuid() == 0){
    80001cc8:	fffff097          	auipc	ra,0xfffff
    80001ccc:	1bc080e7          	jalr	444(ra) # 80000e84 <cpuid>
    80001cd0:	c901                	beqz	a0,80001ce0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cd2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd8:	14479073          	csrw	sip,a5
    return 2;
    80001cdc:	4509                	li	a0,2
    80001cde:	b761                	j	80001c66 <devintr+0x1e>
      clockintr();
    80001ce0:	00000097          	auipc	ra,0x0
    80001ce4:	f22080e7          	jalr	-222(ra) # 80001c02 <clockintr>
    80001ce8:	b7ed                	j	80001cd2 <devintr+0x8a>

0000000080001cea <usertrap>:
{
    80001cea:	1101                	addi	sp,sp,-32
    80001cec:	ec06                	sd	ra,24(sp)
    80001cee:	e822                	sd	s0,16(sp)
    80001cf0:	e426                	sd	s1,8(sp)
    80001cf2:	e04a                	sd	s2,0(sp)
    80001cf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cfa:	1007f793          	andi	a5,a5,256
    80001cfe:	e3b1                	bnez	a5,80001d42 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d00:	00003797          	auipc	a5,0x3
    80001d04:	37078793          	addi	a5,a5,880 # 80005070 <kernelvec>
    80001d08:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	1a4080e7          	jalr	420(ra) # 80000eb0 <myproc>
    80001d14:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d16:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d18:	14102773          	csrr	a4,sepc
    80001d1c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d22:	47a1                	li	a5,8
    80001d24:	02f70763          	beq	a4,a5,80001d52 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	f20080e7          	jalr	-224(ra) # 80001c48 <devintr>
    80001d30:	892a                	mv	s2,a0
    80001d32:	c151                	beqz	a0,80001db6 <usertrap+0xcc>
  if(killed(p))
    80001d34:	8526                	mv	a0,s1
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	ad2080e7          	jalr	-1326(ra) # 80001808 <killed>
    80001d3e:	c929                	beqz	a0,80001d90 <usertrap+0xa6>
    80001d40:	a099                	j	80001d86 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d42:	00006517          	auipc	a0,0x6
    80001d46:	59e50513          	addi	a0,a0,1438 # 800082e0 <states.1723+0x58>
    80001d4a:	00004097          	auipc	ra,0x4
    80001d4e:	f58080e7          	jalr	-168(ra) # 80005ca2 <panic>
    if(killed(p))
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	ab6080e7          	jalr	-1354(ra) # 80001808 <killed>
    80001d5a:	e921                	bnez	a0,80001daa <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d5c:	6cb8                	ld	a4,88(s1)
    80001d5e:	6f1c                	ld	a5,24(a4)
    80001d60:	0791                	addi	a5,a5,4
    80001d62:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	2d4080e7          	jalr	724(ra) # 80002044 <syscall>
  if(killed(p))
    80001d78:	8526                	mv	a0,s1
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	a8e080e7          	jalr	-1394(ra) # 80001808 <killed>
    80001d82:	c911                	beqz	a0,80001d96 <usertrap+0xac>
    80001d84:	4901                	li	s2,0
    exit(-1);
    80001d86:	557d                	li	a0,-1
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	90c080e7          	jalr	-1780(ra) # 80001694 <exit>
  if(which_dev == 2)
    80001d90:	4789                	li	a5,2
    80001d92:	04f90f63          	beq	s2,a5,80001df0 <usertrap+0x106>
  usertrapret();
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	dd6080e7          	jalr	-554(ra) # 80001b6c <usertrapret>
}
    80001d9e:	60e2                	ld	ra,24(sp)
    80001da0:	6442                	ld	s0,16(sp)
    80001da2:	64a2                	ld	s1,8(sp)
    80001da4:	6902                	ld	s2,0(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret
      exit(-1);
    80001daa:	557d                	li	a0,-1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	8e8080e7          	jalr	-1816(ra) # 80001694 <exit>
    80001db4:	b765                	j	80001d5c <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dba:	5890                	lw	a2,48(s1)
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	54450513          	addi	a0,a0,1348 # 80008300 <states.1723+0x78>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	f28080e7          	jalr	-216(ra) # 80005cec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dcc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dd0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	55c50513          	addi	a0,a0,1372 # 80008330 <states.1723+0xa8>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	f10080e7          	jalr	-240(ra) # 80005cec <printf>
    setkilled(p);
    80001de4:	8526                	mv	a0,s1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	9f6080e7          	jalr	-1546(ra) # 800017dc <setkilled>
    80001dee:	b769                	j	80001d78 <usertrap+0x8e>
    yield();
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	734080e7          	jalr	1844(ra) # 80001524 <yield>
    80001df8:	bf79                	j	80001d96 <usertrap+0xac>

0000000080001dfa <kerneltrap>:
{
    80001dfa:	7179                	addi	sp,sp,-48
    80001dfc:	f406                	sd	ra,40(sp)
    80001dfe:	f022                	sd	s0,32(sp)
    80001e00:	ec26                	sd	s1,24(sp)
    80001e02:	e84a                	sd	s2,16(sp)
    80001e04:	e44e                	sd	s3,8(sp)
    80001e06:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e08:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e10:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e14:	1004f793          	andi	a5,s1,256
    80001e18:	cb85                	beqz	a5,80001e48 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e1e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e20:	ef85                	bnez	a5,80001e58 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	e26080e7          	jalr	-474(ra) # 80001c48 <devintr>
    80001e2a:	cd1d                	beqz	a0,80001e68 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e2c:	4789                	li	a5,2
    80001e2e:	06f50a63          	beq	a0,a5,80001ea2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e32:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e36:	10049073          	csrw	sstatus,s1
}
    80001e3a:	70a2                	ld	ra,40(sp)
    80001e3c:	7402                	ld	s0,32(sp)
    80001e3e:	64e2                	ld	s1,24(sp)
    80001e40:	6942                	ld	s2,16(sp)
    80001e42:	69a2                	ld	s3,8(sp)
    80001e44:	6145                	addi	sp,sp,48
    80001e46:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	50850513          	addi	a0,a0,1288 # 80008350 <states.1723+0xc8>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	e52080e7          	jalr	-430(ra) # 80005ca2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e58:	00006517          	auipc	a0,0x6
    80001e5c:	52050513          	addi	a0,a0,1312 # 80008378 <states.1723+0xf0>
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	e42080e7          	jalr	-446(ra) # 80005ca2 <panic>
    printf("scause %p\n", scause);
    80001e68:	85ce                	mv	a1,s3
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	52e50513          	addi	a0,a0,1326 # 80008398 <states.1723+0x110>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	e7a080e7          	jalr	-390(ra) # 80005cec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e7e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	52650513          	addi	a0,a0,1318 # 800083a8 <states.1723+0x120>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	e62080e7          	jalr	-414(ra) # 80005cec <printf>
    panic("kerneltrap");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	52e50513          	addi	a0,a0,1326 # 800083c0 <states.1723+0x138>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	e08080e7          	jalr	-504(ra) # 80005ca2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	00e080e7          	jalr	14(ra) # 80000eb0 <myproc>
    80001eaa:	d541                	beqz	a0,80001e32 <kerneltrap+0x38>
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	004080e7          	jalr	4(ra) # 80000eb0 <myproc>
    80001eb4:	4d18                	lw	a4,24(a0)
    80001eb6:	4791                	li	a5,4
    80001eb8:	f6f71de3          	bne	a4,a5,80001e32 <kerneltrap+0x38>
    yield();
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	668080e7          	jalr	1640(ra) # 80001524 <yield>
    80001ec4:	b7bd                	j	80001e32 <kerneltrap+0x38>

0000000080001ec6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ec6:	1101                	addi	sp,sp,-32
    80001ec8:	ec06                	sd	ra,24(sp)
    80001eca:	e822                	sd	s0,16(sp)
    80001ecc:	e426                	sd	s1,8(sp)
    80001ece:	1000                	addi	s0,sp,32
    80001ed0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	fde080e7          	jalr	-34(ra) # 80000eb0 <myproc>
  switch (n) {
    80001eda:	4795                	li	a5,5
    80001edc:	0497e163          	bltu	a5,s1,80001f1e <argraw+0x58>
    80001ee0:	048a                	slli	s1,s1,0x2
    80001ee2:	00006717          	auipc	a4,0x6
    80001ee6:	5de70713          	addi	a4,a4,1502 # 800084c0 <states.1723+0x238>
    80001eea:	94ba                	add	s1,s1,a4
    80001eec:	409c                	lw	a5,0(s1)
    80001eee:	97ba                	add	a5,a5,a4
    80001ef0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ef2:	6d3c                	ld	a5,88(a0)
    80001ef4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6105                	addi	sp,sp,32
    80001efe:	8082                	ret
    return p->trapframe->a1;
    80001f00:	6d3c                	ld	a5,88(a0)
    80001f02:	7fa8                	ld	a0,120(a5)
    80001f04:	bfcd                	j	80001ef6 <argraw+0x30>
    return p->trapframe->a2;
    80001f06:	6d3c                	ld	a5,88(a0)
    80001f08:	63c8                	ld	a0,128(a5)
    80001f0a:	b7f5                	j	80001ef6 <argraw+0x30>
    return p->trapframe->a3;
    80001f0c:	6d3c                	ld	a5,88(a0)
    80001f0e:	67c8                	ld	a0,136(a5)
    80001f10:	b7dd                	j	80001ef6 <argraw+0x30>
    return p->trapframe->a4;
    80001f12:	6d3c                	ld	a5,88(a0)
    80001f14:	6bc8                	ld	a0,144(a5)
    80001f16:	b7c5                	j	80001ef6 <argraw+0x30>
    return p->trapframe->a5;
    80001f18:	6d3c                	ld	a5,88(a0)
    80001f1a:	6fc8                	ld	a0,152(a5)
    80001f1c:	bfe9                	j	80001ef6 <argraw+0x30>
  panic("argraw");
    80001f1e:	00006517          	auipc	a0,0x6
    80001f22:	4b250513          	addi	a0,a0,1202 # 800083d0 <states.1723+0x148>
    80001f26:	00004097          	auipc	ra,0x4
    80001f2a:	d7c080e7          	jalr	-644(ra) # 80005ca2 <panic>

0000000080001f2e <fetchaddr>:
{
    80001f2e:	1101                	addi	sp,sp,-32
    80001f30:	ec06                	sd	ra,24(sp)
    80001f32:	e822                	sd	s0,16(sp)
    80001f34:	e426                	sd	s1,8(sp)
    80001f36:	e04a                	sd	s2,0(sp)
    80001f38:	1000                	addi	s0,sp,32
    80001f3a:	84aa                	mv	s1,a0
    80001f3c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	f72080e7          	jalr	-142(ra) # 80000eb0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f46:	653c                	ld	a5,72(a0)
    80001f48:	02f4f863          	bgeu	s1,a5,80001f78 <fetchaddr+0x4a>
    80001f4c:	00848713          	addi	a4,s1,8
    80001f50:	02e7e663          	bltu	a5,a4,80001f7c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f54:	46a1                	li	a3,8
    80001f56:	8626                	mv	a2,s1
    80001f58:	85ca                	mv	a1,s2
    80001f5a:	6928                	ld	a0,80(a0)
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	c9e080e7          	jalr	-866(ra) # 80000bfa <copyin>
    80001f64:	00a03533          	snez	a0,a0
    80001f68:	40a00533          	neg	a0,a0
}
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	64a2                	ld	s1,8(sp)
    80001f72:	6902                	ld	s2,0(sp)
    80001f74:	6105                	addi	sp,sp,32
    80001f76:	8082                	ret
    return -1;
    80001f78:	557d                	li	a0,-1
    80001f7a:	bfcd                	j	80001f6c <fetchaddr+0x3e>
    80001f7c:	557d                	li	a0,-1
    80001f7e:	b7fd                	j	80001f6c <fetchaddr+0x3e>

0000000080001f80 <fetchstr>:
{
    80001f80:	7179                	addi	sp,sp,-48
    80001f82:	f406                	sd	ra,40(sp)
    80001f84:	f022                	sd	s0,32(sp)
    80001f86:	ec26                	sd	s1,24(sp)
    80001f88:	e84a                	sd	s2,16(sp)
    80001f8a:	e44e                	sd	s3,8(sp)
    80001f8c:	1800                	addi	s0,sp,48
    80001f8e:	892a                	mv	s2,a0
    80001f90:	84ae                	mv	s1,a1
    80001f92:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	f1c080e7          	jalr	-228(ra) # 80000eb0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f9c:	86ce                	mv	a3,s3
    80001f9e:	864a                	mv	a2,s2
    80001fa0:	85a6                	mv	a1,s1
    80001fa2:	6928                	ld	a0,80(a0)
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	ce2080e7          	jalr	-798(ra) # 80000c86 <copyinstr>
    80001fac:	00054e63          	bltz	a0,80001fc8 <fetchstr+0x48>
  return strlen(buf);
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	ffffe097          	auipc	ra,0xffffe
    80001fb6:	34a080e7          	jalr	842(ra) # 800002fc <strlen>
}
    80001fba:	70a2                	ld	ra,40(sp)
    80001fbc:	7402                	ld	s0,32(sp)
    80001fbe:	64e2                	ld	s1,24(sp)
    80001fc0:	6942                	ld	s2,16(sp)
    80001fc2:	69a2                	ld	s3,8(sp)
    80001fc4:	6145                	addi	sp,sp,48
    80001fc6:	8082                	ret
    return -1;
    80001fc8:	557d                	li	a0,-1
    80001fca:	bfc5                	j	80001fba <fetchstr+0x3a>

0000000080001fcc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	1000                	addi	s0,sp,32
    80001fd6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	eee080e7          	jalr	-274(ra) # 80001ec6 <argraw>
    80001fe0:	c088                	sw	a0,0(s1)
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret

0000000080001fec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	1000                	addi	s0,sp,32
    80001ff6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	ece080e7          	jalr	-306(ra) # 80001ec6 <argraw>
    80002000:	e088                	sd	a0,0(s1)
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	1800                	addi	s0,sp,48
    80002018:	84ae                	mv	s1,a1
    8000201a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000201c:	fd840593          	addi	a1,s0,-40
    80002020:	00000097          	auipc	ra,0x0
    80002024:	fcc080e7          	jalr	-52(ra) # 80001fec <argaddr>
  return fetchstr(addr, buf, max);
    80002028:	864a                	mv	a2,s2
    8000202a:	85a6                	mv	a1,s1
    8000202c:	fd843503          	ld	a0,-40(s0)
    80002030:	00000097          	auipc	ra,0x0
    80002034:	f50080e7          	jalr	-176(ra) # 80001f80 <fetchstr>
}
    80002038:	70a2                	ld	ra,40(sp)
    8000203a:	7402                	ld	s0,32(sp)
    8000203c:	64e2                	ld	s1,24(sp)
    8000203e:	6942                	ld	s2,16(sp)
    80002040:	6145                	addi	sp,sp,48
    80002042:	8082                	ret

0000000080002044 <syscall>:
  "write", "mknod", "unlink", "link",   "mkdir", "close", "trace"
};

void
syscall(void)
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	e5e080e7          	jalr	-418(ra) # 80000eb0 <myproc>
    8000205a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000205c:	05853903          	ld	s2,88(a0)
    80002060:	0a893783          	ld	a5,168(s2)
    80002064:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002068:	37fd                	addiw	a5,a5,-1
    8000206a:	4755                	li	a4,21
    8000206c:	04f76763          	bltu	a4,a5,800020ba <syscall+0x76>
    80002070:	00399713          	slli	a4,s3,0x3
    80002074:	00006797          	auipc	a5,0x6
    80002078:	46478793          	addi	a5,a5,1124 # 800084d8 <syscalls>
    8000207c:	97ba                	add	a5,a5,a4
    8000207e:	639c                	ld	a5,0(a5)
    80002080:	cf8d                	beqz	a5,800020ba <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002082:	9782                	jalr	a5
    80002084:	06a93823          	sd	a0,112(s2)
    if (p->mask & (1 << num))
    80002088:	58dc                	lw	a5,52(s1)
    8000208a:	4137d7bb          	sraw	a5,a5,s3
    8000208e:	8b85                	andi	a5,a5,1
    80002090:	c7a1                	beqz	a5,800020d8 <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscall_list[num],
    80002092:	6cb8                	ld	a4,88(s1)
    80002094:	098e                	slli	s3,s3,0x3
    80002096:	00006797          	auipc	a5,0x6
    8000209a:	44278793          	addi	a5,a5,1090 # 800084d8 <syscalls>
    8000209e:	99be                	add	s3,s3,a5
    800020a0:	7b34                	ld	a3,112(a4)
    800020a2:	0b89b603          	ld	a2,184(s3)
    800020a6:	588c                	lw	a1,48(s1)
    800020a8:	00006517          	auipc	a0,0x6
    800020ac:	33050513          	addi	a0,a0,816 # 800083d8 <states.1723+0x150>
    800020b0:	00004097          	auipc	ra,0x4
    800020b4:	c3c080e7          	jalr	-964(ra) # 80005cec <printf>
    800020b8:	a005                	j	800020d8 <syscall+0x94>
             p->trapframe->a0);
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ba:	86ce                	mv	a3,s3
    800020bc:	15848613          	addi	a2,s1,344
    800020c0:	588c                	lw	a1,48(s1)
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	32e50513          	addi	a0,a0,814 # 800083f0 <states.1723+0x168>
    800020ca:	00004097          	auipc	ra,0x4
    800020ce:	c22080e7          	jalr	-990(ra) # 80005cec <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020d2:	6cbc                	ld	a5,88(s1)
    800020d4:	577d                	li	a4,-1
    800020d6:	fbb8                	sd	a4,112(a5)
  }
}
    800020d8:	70a2                	ld	ra,40(sp)
    800020da:	7402                	ld	s0,32(sp)
    800020dc:	64e2                	ld	s1,24(sp)
    800020de:	6942                	ld	s2,16(sp)
    800020e0:	69a2                	ld	s3,8(sp)
    800020e2:	6145                	addi	sp,sp,48
    800020e4:	8082                	ret

00000000800020e6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020ee:	fec40593          	addi	a1,s0,-20
    800020f2:	4501                	li	a0,0
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	ed8080e7          	jalr	-296(ra) # 80001fcc <argint>
  exit(n);
    800020fc:	fec42503          	lw	a0,-20(s0)
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	594080e7          	jalr	1428(ra) # 80001694 <exit>
  return 0;  // not reached
}
    80002108:	4501                	li	a0,0
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	6105                	addi	sp,sp,32
    80002110:	8082                	ret

0000000080002112 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002112:	1141                	addi	sp,sp,-16
    80002114:	e406                	sd	ra,8(sp)
    80002116:	e022                	sd	s0,0(sp)
    80002118:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	d96080e7          	jalr	-618(ra) # 80000eb0 <myproc>
}
    80002122:	5908                	lw	a0,48(a0)
    80002124:	60a2                	ld	ra,8(sp)
    80002126:	6402                	ld	s0,0(sp)
    80002128:	0141                	addi	sp,sp,16
    8000212a:	8082                	ret

000000008000212c <sys_fork>:

uint64
sys_fork(void)
{
    8000212c:	1141                	addi	sp,sp,-16
    8000212e:	e406                	sd	ra,8(sp)
    80002130:	e022                	sd	s0,0(sp)
    80002132:	0800                	addi	s0,sp,16
  return fork();
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	136080e7          	jalr	310(ra) # 8000126a <fork>
}
    8000213c:	60a2                	ld	ra,8(sp)
    8000213e:	6402                	ld	s0,0(sp)
    80002140:	0141                	addi	sp,sp,16
    80002142:	8082                	ret

0000000080002144 <sys_wait>:

uint64
sys_wait(void)
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000214c:	fe840593          	addi	a1,s0,-24
    80002150:	4501                	li	a0,0
    80002152:	00000097          	auipc	ra,0x0
    80002156:	e9a080e7          	jalr	-358(ra) # 80001fec <argaddr>
  return wait(p);
    8000215a:	fe843503          	ld	a0,-24(s0)
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	6dc080e7          	jalr	1756(ra) # 8000183a <wait>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	6105                	addi	sp,sp,32
    8000216c:	8082                	ret

000000008000216e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000216e:	7179                	addi	sp,sp,-48
    80002170:	f406                	sd	ra,40(sp)
    80002172:	f022                	sd	s0,32(sp)
    80002174:	ec26                	sd	s1,24(sp)
    80002176:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002178:	fdc40593          	addi	a1,s0,-36
    8000217c:	4501                	li	a0,0
    8000217e:	00000097          	auipc	ra,0x0
    80002182:	e4e080e7          	jalr	-434(ra) # 80001fcc <argint>
  addr = myproc()->sz;
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	d2a080e7          	jalr	-726(ra) # 80000eb0 <myproc>
    8000218e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002190:	fdc42503          	lw	a0,-36(s0)
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	07a080e7          	jalr	122(ra) # 8000120e <growproc>
    8000219c:	00054863          	bltz	a0,800021ac <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021a0:	8526                	mv	a0,s1
    800021a2:	70a2                	ld	ra,40(sp)
    800021a4:	7402                	ld	s0,32(sp)
    800021a6:	64e2                	ld	s1,24(sp)
    800021a8:	6145                	addi	sp,sp,48
    800021aa:	8082                	ret
    return -1;
    800021ac:	54fd                	li	s1,-1
    800021ae:	bfcd                	j	800021a0 <sys_sbrk+0x32>

00000000800021b0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021b0:	7139                	addi	sp,sp,-64
    800021b2:	fc06                	sd	ra,56(sp)
    800021b4:	f822                	sd	s0,48(sp)
    800021b6:	f426                	sd	s1,40(sp)
    800021b8:	f04a                	sd	s2,32(sp)
    800021ba:	ec4e                	sd	s3,24(sp)
    800021bc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021be:	fcc40593          	addi	a1,s0,-52
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	e08080e7          	jalr	-504(ra) # 80001fcc <argint>
  if(n < 0)
    800021cc:	fcc42783          	lw	a5,-52(s0)
    800021d0:	0607cf63          	bltz	a5,8000224e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021d4:	0000c517          	auipc	a0,0xc
    800021d8:	6fc50513          	addi	a0,a0,1788 # 8000e8d0 <tickslock>
    800021dc:	00004097          	auipc	ra,0x4
    800021e0:	010080e7          	jalr	16(ra) # 800061ec <acquire>
  ticks0 = ticks;
    800021e4:	00007917          	auipc	s2,0x7
    800021e8:	88492903          	lw	s2,-1916(s2) # 80008a68 <ticks>
  while(ticks - ticks0 < n){
    800021ec:	fcc42783          	lw	a5,-52(s0)
    800021f0:	cf9d                	beqz	a5,8000222e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021f2:	0000c997          	auipc	s3,0xc
    800021f6:	6de98993          	addi	s3,s3,1758 # 8000e8d0 <tickslock>
    800021fa:	00007497          	auipc	s1,0x7
    800021fe:	86e48493          	addi	s1,s1,-1938 # 80008a68 <ticks>
    if(killed(myproc())){
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	cae080e7          	jalr	-850(ra) # 80000eb0 <myproc>
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	5fe080e7          	jalr	1534(ra) # 80001808 <killed>
    80002212:	e129                	bnez	a0,80002254 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002214:	85ce                	mv	a1,s3
    80002216:	8526                	mv	a0,s1
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	348080e7          	jalr	840(ra) # 80001560 <sleep>
  while(ticks - ticks0 < n){
    80002220:	409c                	lw	a5,0(s1)
    80002222:	412787bb          	subw	a5,a5,s2
    80002226:	fcc42703          	lw	a4,-52(s0)
    8000222a:	fce7ece3          	bltu	a5,a4,80002202 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000222e:	0000c517          	auipc	a0,0xc
    80002232:	6a250513          	addi	a0,a0,1698 # 8000e8d0 <tickslock>
    80002236:	00004097          	auipc	ra,0x4
    8000223a:	06a080e7          	jalr	106(ra) # 800062a0 <release>
  return 0;
    8000223e:	4501                	li	a0,0
}
    80002240:	70e2                	ld	ra,56(sp)
    80002242:	7442                	ld	s0,48(sp)
    80002244:	74a2                	ld	s1,40(sp)
    80002246:	7902                	ld	s2,32(sp)
    80002248:	69e2                	ld	s3,24(sp)
    8000224a:	6121                	addi	sp,sp,64
    8000224c:	8082                	ret
    n = 0;
    8000224e:	fc042623          	sw	zero,-52(s0)
    80002252:	b749                	j	800021d4 <sys_sleep+0x24>
      release(&tickslock);
    80002254:	0000c517          	auipc	a0,0xc
    80002258:	67c50513          	addi	a0,a0,1660 # 8000e8d0 <tickslock>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	044080e7          	jalr	68(ra) # 800062a0 <release>
      return -1;
    80002264:	557d                	li	a0,-1
    80002266:	bfe9                	j	80002240 <sys_sleep+0x90>

0000000080002268 <sys_kill>:

uint64
sys_kill(void)
{
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002270:	fec40593          	addi	a1,s0,-20
    80002274:	4501                	li	a0,0
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	d56080e7          	jalr	-682(ra) # 80001fcc <argint>
  return kill(pid);
    8000227e:	fec42503          	lw	a0,-20(s0)
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	4e8080e7          	jalr	1256(ra) # 8000176a <kill>
}
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret

0000000080002292 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002292:	1101                	addi	sp,sp,-32
    80002294:	ec06                	sd	ra,24(sp)
    80002296:	e822                	sd	s0,16(sp)
    80002298:	e426                	sd	s1,8(sp)
    8000229a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000229c:	0000c517          	auipc	a0,0xc
    800022a0:	63450513          	addi	a0,a0,1588 # 8000e8d0 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	f48080e7          	jalr	-184(ra) # 800061ec <acquire>
  xticks = ticks;
    800022ac:	00006497          	auipc	s1,0x6
    800022b0:	7bc4a483          	lw	s1,1980(s1) # 80008a68 <ticks>
  release(&tickslock);
    800022b4:	0000c517          	auipc	a0,0xc
    800022b8:	61c50513          	addi	a0,a0,1564 # 8000e8d0 <tickslock>
    800022bc:	00004097          	auipc	ra,0x4
    800022c0:	fe4080e7          	jalr	-28(ra) # 800062a0 <release>
  return xticks;
}
    800022c4:	02049513          	slli	a0,s1,0x20
    800022c8:	9101                	srli	a0,a0,0x20
    800022ca:	60e2                	ld	ra,24(sp)
    800022cc:	6442                	ld	s0,16(sp)
    800022ce:	64a2                	ld	s1,8(sp)
    800022d0:	6105                	addi	sp,sp,32
    800022d2:	8082                	ret

00000000800022d4 <sys_trace>:


uint64
sys_trace(void)
{
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	1000                	addi	s0,sp,32
  int mask;

  argint(0, &mask);
    800022dc:	fec40593          	addi	a1,s0,-20
    800022e0:	4501                	li	a0,0
    800022e2:	00000097          	auipc	ra,0x0
    800022e6:	cea080e7          	jalr	-790(ra) # 80001fcc <argint>

  myproc()->mask = mask;
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	bc6080e7          	jalr	-1082(ra) # 80000eb0 <myproc>
    800022f2:	fec42783          	lw	a5,-20(s0)
    800022f6:	d95c                	sw	a5,52(a0)

  return 0;
}
    800022f8:	4501                	li	a0,0
    800022fa:	60e2                	ld	ra,24(sp)
    800022fc:	6442                	ld	s0,16(sp)
    800022fe:	6105                	addi	sp,sp,32
    80002300:	8082                	ret

0000000080002302 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002302:	7179                	addi	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	e84a                	sd	s2,16(sp)
    8000230c:	e44e                	sd	s3,8(sp)
    8000230e:	e052                	sd	s4,0(sp)
    80002310:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002312:	00006597          	auipc	a1,0x6
    80002316:	33658593          	addi	a1,a1,822 # 80008648 <syscall_list+0xb8>
    8000231a:	0000c517          	auipc	a0,0xc
    8000231e:	5ce50513          	addi	a0,a0,1486 # 8000e8e8 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	e3a080e7          	jalr	-454(ra) # 8000615c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000232a:	00014797          	auipc	a5,0x14
    8000232e:	5be78793          	addi	a5,a5,1470 # 800168e8 <bcache+0x8000>
    80002332:	00015717          	auipc	a4,0x15
    80002336:	81e70713          	addi	a4,a4,-2018 # 80016b50 <bcache+0x8268>
    8000233a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000233e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002342:	0000c497          	auipc	s1,0xc
    80002346:	5be48493          	addi	s1,s1,1470 # 8000e900 <bcache+0x18>
    b->next = bcache.head.next;
    8000234a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000234c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000234e:	00006a17          	auipc	s4,0x6
    80002352:	302a0a13          	addi	s4,s4,770 # 80008650 <syscall_list+0xc0>
    b->next = bcache.head.next;
    80002356:	2b893783          	ld	a5,696(s2)
    8000235a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000235c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002360:	85d2                	mv	a1,s4
    80002362:	01048513          	addi	a0,s1,16
    80002366:	00001097          	auipc	ra,0x1
    8000236a:	4c4080e7          	jalr	1220(ra) # 8000382a <initsleeplock>
    bcache.head.next->prev = b;
    8000236e:	2b893783          	ld	a5,696(s2)
    80002372:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002374:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002378:	45848493          	addi	s1,s1,1112
    8000237c:	fd349de3          	bne	s1,s3,80002356 <binit+0x54>
  }
}
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6a02                	ld	s4,0(sp)
    8000238c:	6145                	addi	sp,sp,48
    8000238e:	8082                	ret

0000000080002390 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002390:	7179                	addi	sp,sp,-48
    80002392:	f406                	sd	ra,40(sp)
    80002394:	f022                	sd	s0,32(sp)
    80002396:	ec26                	sd	s1,24(sp)
    80002398:	e84a                	sd	s2,16(sp)
    8000239a:	e44e                	sd	s3,8(sp)
    8000239c:	1800                	addi	s0,sp,48
    8000239e:	89aa                	mv	s3,a0
    800023a0:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023a2:	0000c517          	auipc	a0,0xc
    800023a6:	54650513          	addi	a0,a0,1350 # 8000e8e8 <bcache>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	e42080e7          	jalr	-446(ra) # 800061ec <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b2:	00014497          	auipc	s1,0x14
    800023b6:	7ee4b483          	ld	s1,2030(s1) # 80016ba0 <bcache+0x82b8>
    800023ba:	00014797          	auipc	a5,0x14
    800023be:	79678793          	addi	a5,a5,1942 # 80016b50 <bcache+0x8268>
    800023c2:	02f48f63          	beq	s1,a5,80002400 <bread+0x70>
    800023c6:	873e                	mv	a4,a5
    800023c8:	a021                	j	800023d0 <bread+0x40>
    800023ca:	68a4                	ld	s1,80(s1)
    800023cc:	02e48a63          	beq	s1,a4,80002400 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d0:	449c                	lw	a5,8(s1)
    800023d2:	ff379ce3          	bne	a5,s3,800023ca <bread+0x3a>
    800023d6:	44dc                	lw	a5,12(s1)
    800023d8:	ff2799e3          	bne	a5,s2,800023ca <bread+0x3a>
      b->refcnt++;
    800023dc:	40bc                	lw	a5,64(s1)
    800023de:	2785                	addiw	a5,a5,1
    800023e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e2:	0000c517          	auipc	a0,0xc
    800023e6:	50650513          	addi	a0,a0,1286 # 8000e8e8 <bcache>
    800023ea:	00004097          	auipc	ra,0x4
    800023ee:	eb6080e7          	jalr	-330(ra) # 800062a0 <release>
      acquiresleep(&b->lock);
    800023f2:	01048513          	addi	a0,s1,16
    800023f6:	00001097          	auipc	ra,0x1
    800023fa:	46e080e7          	jalr	1134(ra) # 80003864 <acquiresleep>
      return b;
    800023fe:	a8b9                	j	8000245c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002400:	00014497          	auipc	s1,0x14
    80002404:	7984b483          	ld	s1,1944(s1) # 80016b98 <bcache+0x82b0>
    80002408:	00014797          	auipc	a5,0x14
    8000240c:	74878793          	addi	a5,a5,1864 # 80016b50 <bcache+0x8268>
    80002410:	00f48863          	beq	s1,a5,80002420 <bread+0x90>
    80002414:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	cf81                	beqz	a5,80002430 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241a:	64a4                	ld	s1,72(s1)
    8000241c:	fee49de3          	bne	s1,a4,80002416 <bread+0x86>
  panic("bget: no buffers");
    80002420:	00006517          	auipc	a0,0x6
    80002424:	23850513          	addi	a0,a0,568 # 80008658 <syscall_list+0xc8>
    80002428:	00004097          	auipc	ra,0x4
    8000242c:	87a080e7          	jalr	-1926(ra) # 80005ca2 <panic>
      b->dev = dev;
    80002430:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002434:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002438:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000243c:	4785                	li	a5,1
    8000243e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002440:	0000c517          	auipc	a0,0xc
    80002444:	4a850513          	addi	a0,a0,1192 # 8000e8e8 <bcache>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	e58080e7          	jalr	-424(ra) # 800062a0 <release>
      acquiresleep(&b->lock);
    80002450:	01048513          	addi	a0,s1,16
    80002454:	00001097          	auipc	ra,0x1
    80002458:	410080e7          	jalr	1040(ra) # 80003864 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000245c:	409c                	lw	a5,0(s1)
    8000245e:	cb89                	beqz	a5,80002470 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002460:	8526                	mv	a0,s1
    80002462:	70a2                	ld	ra,40(sp)
    80002464:	7402                	ld	s0,32(sp)
    80002466:	64e2                	ld	s1,24(sp)
    80002468:	6942                	ld	s2,16(sp)
    8000246a:	69a2                	ld	s3,8(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002470:	4581                	li	a1,0
    80002472:	8526                	mv	a0,s1
    80002474:	00003097          	auipc	ra,0x3
    80002478:	fc4080e7          	jalr	-60(ra) # 80005438 <virtio_disk_rw>
    b->valid = 1;
    8000247c:	4785                	li	a5,1
    8000247e:	c09c                	sw	a5,0(s1)
  return b;
    80002480:	b7c5                	j	80002460 <bread+0xd0>

0000000080002482 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002482:	1101                	addi	sp,sp,-32
    80002484:	ec06                	sd	ra,24(sp)
    80002486:	e822                	sd	s0,16(sp)
    80002488:	e426                	sd	s1,8(sp)
    8000248a:	1000                	addi	s0,sp,32
    8000248c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248e:	0541                	addi	a0,a0,16
    80002490:	00001097          	auipc	ra,0x1
    80002494:	46e080e7          	jalr	1134(ra) # 800038fe <holdingsleep>
    80002498:	cd01                	beqz	a0,800024b0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000249a:	4585                	li	a1,1
    8000249c:	8526                	mv	a0,s1
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	f9a080e7          	jalr	-102(ra) # 80005438 <virtio_disk_rw>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    panic("bwrite");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	1c050513          	addi	a0,a0,448 # 80008670 <syscall_list+0xe0>
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	7ea080e7          	jalr	2026(ra) # 80005ca2 <panic>

00000000800024c0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	e04a                	sd	s2,0(sp)
    800024ca:	1000                	addi	s0,sp,32
    800024cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ce:	01050913          	addi	s2,a0,16
    800024d2:	854a                	mv	a0,s2
    800024d4:	00001097          	auipc	ra,0x1
    800024d8:	42a080e7          	jalr	1066(ra) # 800038fe <holdingsleep>
    800024dc:	c92d                	beqz	a0,8000254e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024de:	854a                	mv	a0,s2
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	3da080e7          	jalr	986(ra) # 800038ba <releasesleep>

  acquire(&bcache.lock);
    800024e8:	0000c517          	auipc	a0,0xc
    800024ec:	40050513          	addi	a0,a0,1024 # 8000e8e8 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	cfc080e7          	jalr	-772(ra) # 800061ec <acquire>
  b->refcnt--;
    800024f8:	40bc                	lw	a5,64(s1)
    800024fa:	37fd                	addiw	a5,a5,-1
    800024fc:	0007871b          	sext.w	a4,a5
    80002500:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002502:	eb05                	bnez	a4,80002532 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002504:	68bc                	ld	a5,80(s1)
    80002506:	64b8                	ld	a4,72(s1)
    80002508:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000250a:	64bc                	ld	a5,72(s1)
    8000250c:	68b8                	ld	a4,80(s1)
    8000250e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002510:	00014797          	auipc	a5,0x14
    80002514:	3d878793          	addi	a5,a5,984 # 800168e8 <bcache+0x8000>
    80002518:	2b87b703          	ld	a4,696(a5)
    8000251c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000251e:	00014717          	auipc	a4,0x14
    80002522:	63270713          	addi	a4,a4,1586 # 80016b50 <bcache+0x8268>
    80002526:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002528:	2b87b703          	ld	a4,696(a5)
    8000252c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000252e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002532:	0000c517          	auipc	a0,0xc
    80002536:	3b650513          	addi	a0,a0,950 # 8000e8e8 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	d66080e7          	jalr	-666(ra) # 800062a0 <release>
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	6902                	ld	s2,0(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret
    panic("brelse");
    8000254e:	00006517          	auipc	a0,0x6
    80002552:	12a50513          	addi	a0,a0,298 # 80008678 <syscall_list+0xe8>
    80002556:	00003097          	auipc	ra,0x3
    8000255a:	74c080e7          	jalr	1868(ra) # 80005ca2 <panic>

000000008000255e <bpin>:

void
bpin(struct buf *b) {
    8000255e:	1101                	addi	sp,sp,-32
    80002560:	ec06                	sd	ra,24(sp)
    80002562:	e822                	sd	s0,16(sp)
    80002564:	e426                	sd	s1,8(sp)
    80002566:	1000                	addi	s0,sp,32
    80002568:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256a:	0000c517          	auipc	a0,0xc
    8000256e:	37e50513          	addi	a0,a0,894 # 8000e8e8 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	c7a080e7          	jalr	-902(ra) # 800061ec <acquire>
  b->refcnt++;
    8000257a:	40bc                	lw	a5,64(s1)
    8000257c:	2785                	addiw	a5,a5,1
    8000257e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002580:	0000c517          	auipc	a0,0xc
    80002584:	36850513          	addi	a0,a0,872 # 8000e8e8 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	d18080e7          	jalr	-744(ra) # 800062a0 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret

000000008000259a <bunpin>:

void
bunpin(struct buf *b) {
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	1000                	addi	s0,sp,32
    800025a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a6:	0000c517          	auipc	a0,0xc
    800025aa:	34250513          	addi	a0,a0,834 # 8000e8e8 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	c3e080e7          	jalr	-962(ra) # 800061ec <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025bc:	0000c517          	auipc	a0,0xc
    800025c0:	32c50513          	addi	a0,a0,812 # 8000e8e8 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	cdc080e7          	jalr	-804(ra) # 800062a0 <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret

00000000800025d6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	e04a                	sd	s2,0(sp)
    800025e0:	1000                	addi	s0,sp,32
    800025e2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e4:	00d5d59b          	srliw	a1,a1,0xd
    800025e8:	00015797          	auipc	a5,0x15
    800025ec:	9dc7a783          	lw	a5,-1572(a5) # 80016fc4 <sb+0x1c>
    800025f0:	9dbd                	addw	a1,a1,a5
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	d9e080e7          	jalr	-610(ra) # 80002390 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025fa:	0074f713          	andi	a4,s1,7
    800025fe:	4785                	li	a5,1
    80002600:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002604:	14ce                	slli	s1,s1,0x33
    80002606:	90d9                	srli	s1,s1,0x36
    80002608:	00950733          	add	a4,a0,s1
    8000260c:	05874703          	lbu	a4,88(a4)
    80002610:	00e7f6b3          	and	a3,a5,a4
    80002614:	c69d                	beqz	a3,80002642 <bfree+0x6c>
    80002616:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002618:	94aa                	add	s1,s1,a0
    8000261a:	fff7c793          	not	a5,a5
    8000261e:	8ff9                	and	a5,a5,a4
    80002620:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002624:	00001097          	auipc	ra,0x1
    80002628:	120080e7          	jalr	288(ra) # 80003744 <log_write>
  brelse(bp);
    8000262c:	854a                	mv	a0,s2
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	e92080e7          	jalr	-366(ra) # 800024c0 <brelse>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6902                	ld	s2,0(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret
    panic("freeing free block");
    80002642:	00006517          	auipc	a0,0x6
    80002646:	03e50513          	addi	a0,a0,62 # 80008680 <syscall_list+0xf0>
    8000264a:	00003097          	auipc	ra,0x3
    8000264e:	658080e7          	jalr	1624(ra) # 80005ca2 <panic>

0000000080002652 <balloc>:
{
    80002652:	711d                	addi	sp,sp,-96
    80002654:	ec86                	sd	ra,88(sp)
    80002656:	e8a2                	sd	s0,80(sp)
    80002658:	e4a6                	sd	s1,72(sp)
    8000265a:	e0ca                	sd	s2,64(sp)
    8000265c:	fc4e                	sd	s3,56(sp)
    8000265e:	f852                	sd	s4,48(sp)
    80002660:	f456                	sd	s5,40(sp)
    80002662:	f05a                	sd	s6,32(sp)
    80002664:	ec5e                	sd	s7,24(sp)
    80002666:	e862                	sd	s8,16(sp)
    80002668:	e466                	sd	s9,8(sp)
    8000266a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000266c:	00015797          	auipc	a5,0x15
    80002670:	9407a783          	lw	a5,-1728(a5) # 80016fac <sb+0x4>
    80002674:	10078163          	beqz	a5,80002776 <balloc+0x124>
    80002678:	8baa                	mv	s7,a0
    8000267a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000267c:	00015b17          	auipc	s6,0x15
    80002680:	92cb0b13          	addi	s6,s6,-1748 # 80016fa8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002684:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002686:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002688:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000268a:	6c89                	lui	s9,0x2
    8000268c:	a061                	j	80002714 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000268e:	974a                	add	a4,a4,s2
    80002690:	8fd5                	or	a5,a5,a3
    80002692:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002696:	854a                	mv	a0,s2
    80002698:	00001097          	auipc	ra,0x1
    8000269c:	0ac080e7          	jalr	172(ra) # 80003744 <log_write>
        brelse(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	e1e080e7          	jalr	-482(ra) # 800024c0 <brelse>
  bp = bread(dev, bno);
    800026aa:	85a6                	mv	a1,s1
    800026ac:	855e                	mv	a0,s7
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	ce2080e7          	jalr	-798(ra) # 80002390 <bread>
    800026b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026b8:	40000613          	li	a2,1024
    800026bc:	4581                	li	a1,0
    800026be:	05850513          	addi	a0,a0,88
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	ab6080e7          	jalr	-1354(ra) # 80000178 <memset>
  log_write(bp);
    800026ca:	854a                	mv	a0,s2
    800026cc:	00001097          	auipc	ra,0x1
    800026d0:	078080e7          	jalr	120(ra) # 80003744 <log_write>
  brelse(bp);
    800026d4:	854a                	mv	a0,s2
    800026d6:	00000097          	auipc	ra,0x0
    800026da:	dea080e7          	jalr	-534(ra) # 800024c0 <brelse>
}
    800026de:	8526                	mv	a0,s1
    800026e0:	60e6                	ld	ra,88(sp)
    800026e2:	6446                	ld	s0,80(sp)
    800026e4:	64a6                	ld	s1,72(sp)
    800026e6:	6906                	ld	s2,64(sp)
    800026e8:	79e2                	ld	s3,56(sp)
    800026ea:	7a42                	ld	s4,48(sp)
    800026ec:	7aa2                	ld	s5,40(sp)
    800026ee:	7b02                	ld	s6,32(sp)
    800026f0:	6be2                	ld	s7,24(sp)
    800026f2:	6c42                	ld	s8,16(sp)
    800026f4:	6ca2                	ld	s9,8(sp)
    800026f6:	6125                	addi	sp,sp,96
    800026f8:	8082                	ret
    brelse(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	00000097          	auipc	ra,0x0
    80002700:	dc4080e7          	jalr	-572(ra) # 800024c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002704:	015c87bb          	addw	a5,s9,s5
    80002708:	00078a9b          	sext.w	s5,a5
    8000270c:	004b2703          	lw	a4,4(s6)
    80002710:	06eaf363          	bgeu	s5,a4,80002776 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002714:	41fad79b          	sraiw	a5,s5,0x1f
    80002718:	0137d79b          	srliw	a5,a5,0x13
    8000271c:	015787bb          	addw	a5,a5,s5
    80002720:	40d7d79b          	sraiw	a5,a5,0xd
    80002724:	01cb2583          	lw	a1,28(s6)
    80002728:	9dbd                	addw	a1,a1,a5
    8000272a:	855e                	mv	a0,s7
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	c64080e7          	jalr	-924(ra) # 80002390 <bread>
    80002734:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002736:	004b2503          	lw	a0,4(s6)
    8000273a:	000a849b          	sext.w	s1,s5
    8000273e:	8662                	mv	a2,s8
    80002740:	faa4fde3          	bgeu	s1,a0,800026fa <balloc+0xa8>
      m = 1 << (bi % 8);
    80002744:	41f6579b          	sraiw	a5,a2,0x1f
    80002748:	01d7d69b          	srliw	a3,a5,0x1d
    8000274c:	00c6873b          	addw	a4,a3,a2
    80002750:	00777793          	andi	a5,a4,7
    80002754:	9f95                	subw	a5,a5,a3
    80002756:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000275a:	4037571b          	sraiw	a4,a4,0x3
    8000275e:	00e906b3          	add	a3,s2,a4
    80002762:	0586c683          	lbu	a3,88(a3)
    80002766:	00d7f5b3          	and	a1,a5,a3
    8000276a:	d195                	beqz	a1,8000268e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276c:	2605                	addiw	a2,a2,1
    8000276e:	2485                	addiw	s1,s1,1
    80002770:	fd4618e3          	bne	a2,s4,80002740 <balloc+0xee>
    80002774:	b759                	j	800026fa <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	f2250513          	addi	a0,a0,-222 # 80008698 <syscall_list+0x108>
    8000277e:	00003097          	auipc	ra,0x3
    80002782:	56e080e7          	jalr	1390(ra) # 80005cec <printf>
  return 0;
    80002786:	4481                	li	s1,0
    80002788:	bf99                	j	800026de <balloc+0x8c>

000000008000278a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000278a:	7179                	addi	sp,sp,-48
    8000278c:	f406                	sd	ra,40(sp)
    8000278e:	f022                	sd	s0,32(sp)
    80002790:	ec26                	sd	s1,24(sp)
    80002792:	e84a                	sd	s2,16(sp)
    80002794:	e44e                	sd	s3,8(sp)
    80002796:	e052                	sd	s4,0(sp)
    80002798:	1800                	addi	s0,sp,48
    8000279a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000279c:	47ad                	li	a5,11
    8000279e:	02b7e763          	bltu	a5,a1,800027cc <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027a2:	02059493          	slli	s1,a1,0x20
    800027a6:	9081                	srli	s1,s1,0x20
    800027a8:	048a                	slli	s1,s1,0x2
    800027aa:	94aa                	add	s1,s1,a0
    800027ac:	0504a903          	lw	s2,80(s1)
    800027b0:	06091e63          	bnez	s2,8000282c <bmap+0xa2>
      addr = balloc(ip->dev);
    800027b4:	4108                	lw	a0,0(a0)
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	e9c080e7          	jalr	-356(ra) # 80002652 <balloc>
    800027be:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027c2:	06090563          	beqz	s2,8000282c <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800027c6:	0524a823          	sw	s2,80(s1)
    800027ca:	a08d                	j	8000282c <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027cc:	ff45849b          	addiw	s1,a1,-12
    800027d0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027d4:	0ff00793          	li	a5,255
    800027d8:	08e7e563          	bltu	a5,a4,80002862 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027dc:	08052903          	lw	s2,128(a0)
    800027e0:	00091d63          	bnez	s2,800027fa <bmap+0x70>
      addr = balloc(ip->dev);
    800027e4:	4108                	lw	a0,0(a0)
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	e6c080e7          	jalr	-404(ra) # 80002652 <balloc>
    800027ee:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027f2:	02090d63          	beqz	s2,8000282c <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027f6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027fa:	85ca                	mv	a1,s2
    800027fc:	0009a503          	lw	a0,0(s3)
    80002800:	00000097          	auipc	ra,0x0
    80002804:	b90080e7          	jalr	-1136(ra) # 80002390 <bread>
    80002808:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000280a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000280e:	02049593          	slli	a1,s1,0x20
    80002812:	9181                	srli	a1,a1,0x20
    80002814:	058a                	slli	a1,a1,0x2
    80002816:	00b784b3          	add	s1,a5,a1
    8000281a:	0004a903          	lw	s2,0(s1)
    8000281e:	02090063          	beqz	s2,8000283e <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002822:	8552                	mv	a0,s4
    80002824:	00000097          	auipc	ra,0x0
    80002828:	c9c080e7          	jalr	-868(ra) # 800024c0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000282c:	854a                	mv	a0,s2
    8000282e:	70a2                	ld	ra,40(sp)
    80002830:	7402                	ld	s0,32(sp)
    80002832:	64e2                	ld	s1,24(sp)
    80002834:	6942                	ld	s2,16(sp)
    80002836:	69a2                	ld	s3,8(sp)
    80002838:	6a02                	ld	s4,0(sp)
    8000283a:	6145                	addi	sp,sp,48
    8000283c:	8082                	ret
      addr = balloc(ip->dev);
    8000283e:	0009a503          	lw	a0,0(s3)
    80002842:	00000097          	auipc	ra,0x0
    80002846:	e10080e7          	jalr	-496(ra) # 80002652 <balloc>
    8000284a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000284e:	fc090ae3          	beqz	s2,80002822 <bmap+0x98>
        a[bn] = addr;
    80002852:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002856:	8552                	mv	a0,s4
    80002858:	00001097          	auipc	ra,0x1
    8000285c:	eec080e7          	jalr	-276(ra) # 80003744 <log_write>
    80002860:	b7c9                	j	80002822 <bmap+0x98>
  panic("bmap: out of range");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	e4e50513          	addi	a0,a0,-434 # 800086b0 <syscall_list+0x120>
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	438080e7          	jalr	1080(ra) # 80005ca2 <panic>

0000000080002872 <iget>:
{
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	e052                	sd	s4,0(sp)
    80002880:	1800                	addi	s0,sp,48
    80002882:	89aa                	mv	s3,a0
    80002884:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002886:	00014517          	auipc	a0,0x14
    8000288a:	74250513          	addi	a0,a0,1858 # 80016fc8 <itable>
    8000288e:	00004097          	auipc	ra,0x4
    80002892:	95e080e7          	jalr	-1698(ra) # 800061ec <acquire>
  empty = 0;
    80002896:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002898:	00014497          	auipc	s1,0x14
    8000289c:	74848493          	addi	s1,s1,1864 # 80016fe0 <itable+0x18>
    800028a0:	00016697          	auipc	a3,0x16
    800028a4:	1d068693          	addi	a3,a3,464 # 80018a70 <log>
    800028a8:	a039                	j	800028b6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028aa:	02090b63          	beqz	s2,800028e0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ae:	08848493          	addi	s1,s1,136
    800028b2:	02d48a63          	beq	s1,a3,800028e6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b6:	449c                	lw	a5,8(s1)
    800028b8:	fef059e3          	blez	a5,800028aa <iget+0x38>
    800028bc:	4098                	lw	a4,0(s1)
    800028be:	ff3716e3          	bne	a4,s3,800028aa <iget+0x38>
    800028c2:	40d8                	lw	a4,4(s1)
    800028c4:	ff4713e3          	bne	a4,s4,800028aa <iget+0x38>
      ip->ref++;
    800028c8:	2785                	addiw	a5,a5,1
    800028ca:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028cc:	00014517          	auipc	a0,0x14
    800028d0:	6fc50513          	addi	a0,a0,1788 # 80016fc8 <itable>
    800028d4:	00004097          	auipc	ra,0x4
    800028d8:	9cc080e7          	jalr	-1588(ra) # 800062a0 <release>
      return ip;
    800028dc:	8926                	mv	s2,s1
    800028de:	a03d                	j	8000290c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e0:	f7f9                	bnez	a5,800028ae <iget+0x3c>
    800028e2:	8926                	mv	s2,s1
    800028e4:	b7e9                	j	800028ae <iget+0x3c>
  if(empty == 0)
    800028e6:	02090c63          	beqz	s2,8000291e <iget+0xac>
  ip->dev = dev;
    800028ea:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028ee:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f2:	4785                	li	a5,1
    800028f4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fc:	00014517          	auipc	a0,0x14
    80002900:	6cc50513          	addi	a0,a0,1740 # 80016fc8 <itable>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	99c080e7          	jalr	-1636(ra) # 800062a0 <release>
}
    8000290c:	854a                	mv	a0,s2
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6a02                	ld	s4,0(sp)
    8000291a:	6145                	addi	sp,sp,48
    8000291c:	8082                	ret
    panic("iget: no inodes");
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	daa50513          	addi	a0,a0,-598 # 800086c8 <syscall_list+0x138>
    80002926:	00003097          	auipc	ra,0x3
    8000292a:	37c080e7          	jalr	892(ra) # 80005ca2 <panic>

000000008000292e <fsinit>:
fsinit(int dev) {
    8000292e:	7179                	addi	sp,sp,-48
    80002930:	f406                	sd	ra,40(sp)
    80002932:	f022                	sd	s0,32(sp)
    80002934:	ec26                	sd	s1,24(sp)
    80002936:	e84a                	sd	s2,16(sp)
    80002938:	e44e                	sd	s3,8(sp)
    8000293a:	1800                	addi	s0,sp,48
    8000293c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000293e:	4585                	li	a1,1
    80002940:	00000097          	auipc	ra,0x0
    80002944:	a50080e7          	jalr	-1456(ra) # 80002390 <bread>
    80002948:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000294a:	00014997          	auipc	s3,0x14
    8000294e:	65e98993          	addi	s3,s3,1630 # 80016fa8 <sb>
    80002952:	02000613          	li	a2,32
    80002956:	05850593          	addi	a1,a0,88
    8000295a:	854e                	mv	a0,s3
    8000295c:	ffffe097          	auipc	ra,0xffffe
    80002960:	87c080e7          	jalr	-1924(ra) # 800001d8 <memmove>
  brelse(bp);
    80002964:	8526                	mv	a0,s1
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	b5a080e7          	jalr	-1190(ra) # 800024c0 <brelse>
  if(sb.magic != FSMAGIC)
    8000296e:	0009a703          	lw	a4,0(s3)
    80002972:	102037b7          	lui	a5,0x10203
    80002976:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000297a:	02f71263          	bne	a4,a5,8000299e <fsinit+0x70>
  initlog(dev, &sb);
    8000297e:	00014597          	auipc	a1,0x14
    80002982:	62a58593          	addi	a1,a1,1578 # 80016fa8 <sb>
    80002986:	854a                	mv	a0,s2
    80002988:	00001097          	auipc	ra,0x1
    8000298c:	b40080e7          	jalr	-1216(ra) # 800034c8 <initlog>
}
    80002990:	70a2                	ld	ra,40(sp)
    80002992:	7402                	ld	s0,32(sp)
    80002994:	64e2                	ld	s1,24(sp)
    80002996:	6942                	ld	s2,16(sp)
    80002998:	69a2                	ld	s3,8(sp)
    8000299a:	6145                	addi	sp,sp,48
    8000299c:	8082                	ret
    panic("invalid file system");
    8000299e:	00006517          	auipc	a0,0x6
    800029a2:	d3a50513          	addi	a0,a0,-710 # 800086d8 <syscall_list+0x148>
    800029a6:	00003097          	auipc	ra,0x3
    800029aa:	2fc080e7          	jalr	764(ra) # 80005ca2 <panic>

00000000800029ae <iinit>:
{
    800029ae:	7179                	addi	sp,sp,-48
    800029b0:	f406                	sd	ra,40(sp)
    800029b2:	f022                	sd	s0,32(sp)
    800029b4:	ec26                	sd	s1,24(sp)
    800029b6:	e84a                	sd	s2,16(sp)
    800029b8:	e44e                	sd	s3,8(sp)
    800029ba:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029bc:	00006597          	auipc	a1,0x6
    800029c0:	d3458593          	addi	a1,a1,-716 # 800086f0 <syscall_list+0x160>
    800029c4:	00014517          	auipc	a0,0x14
    800029c8:	60450513          	addi	a0,a0,1540 # 80016fc8 <itable>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	790080e7          	jalr	1936(ra) # 8000615c <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d4:	00014497          	auipc	s1,0x14
    800029d8:	61c48493          	addi	s1,s1,1564 # 80016ff0 <itable+0x28>
    800029dc:	00016997          	auipc	s3,0x16
    800029e0:	0a498993          	addi	s3,s3,164 # 80018a80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e4:	00006917          	auipc	s2,0x6
    800029e8:	d1490913          	addi	s2,s2,-748 # 800086f8 <syscall_list+0x168>
    800029ec:	85ca                	mv	a1,s2
    800029ee:	8526                	mv	a0,s1
    800029f0:	00001097          	auipc	ra,0x1
    800029f4:	e3a080e7          	jalr	-454(ra) # 8000382a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f8:	08848493          	addi	s1,s1,136
    800029fc:	ff3498e3          	bne	s1,s3,800029ec <iinit+0x3e>
}
    80002a00:	70a2                	ld	ra,40(sp)
    80002a02:	7402                	ld	s0,32(sp)
    80002a04:	64e2                	ld	s1,24(sp)
    80002a06:	6942                	ld	s2,16(sp)
    80002a08:	69a2                	ld	s3,8(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret

0000000080002a0e <ialloc>:
{
    80002a0e:	715d                	addi	sp,sp,-80
    80002a10:	e486                	sd	ra,72(sp)
    80002a12:	e0a2                	sd	s0,64(sp)
    80002a14:	fc26                	sd	s1,56(sp)
    80002a16:	f84a                	sd	s2,48(sp)
    80002a18:	f44e                	sd	s3,40(sp)
    80002a1a:	f052                	sd	s4,32(sp)
    80002a1c:	ec56                	sd	s5,24(sp)
    80002a1e:	e85a                	sd	s6,16(sp)
    80002a20:	e45e                	sd	s7,8(sp)
    80002a22:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a24:	00014717          	auipc	a4,0x14
    80002a28:	59072703          	lw	a4,1424(a4) # 80016fb4 <sb+0xc>
    80002a2c:	4785                	li	a5,1
    80002a2e:	04e7fa63          	bgeu	a5,a4,80002a82 <ialloc+0x74>
    80002a32:	8aaa                	mv	s5,a0
    80002a34:	8bae                	mv	s7,a1
    80002a36:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a38:	00014a17          	auipc	s4,0x14
    80002a3c:	570a0a13          	addi	s4,s4,1392 # 80016fa8 <sb>
    80002a40:	00048b1b          	sext.w	s6,s1
    80002a44:	0044d593          	srli	a1,s1,0x4
    80002a48:	018a2783          	lw	a5,24(s4)
    80002a4c:	9dbd                	addw	a1,a1,a5
    80002a4e:	8556                	mv	a0,s5
    80002a50:	00000097          	auipc	ra,0x0
    80002a54:	940080e7          	jalr	-1728(ra) # 80002390 <bread>
    80002a58:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a5a:	05850993          	addi	s3,a0,88
    80002a5e:	00f4f793          	andi	a5,s1,15
    80002a62:	079a                	slli	a5,a5,0x6
    80002a64:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a66:	00099783          	lh	a5,0(s3)
    80002a6a:	c3a1                	beqz	a5,80002aaa <ialloc+0x9c>
    brelse(bp);
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	a54080e7          	jalr	-1452(ra) # 800024c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a74:	0485                	addi	s1,s1,1
    80002a76:	00ca2703          	lw	a4,12(s4)
    80002a7a:	0004879b          	sext.w	a5,s1
    80002a7e:	fce7e1e3          	bltu	a5,a4,80002a40 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	c7e50513          	addi	a0,a0,-898 # 80008700 <syscall_list+0x170>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	262080e7          	jalr	610(ra) # 80005cec <printf>
  return 0;
    80002a92:	4501                	li	a0,0
}
    80002a94:	60a6                	ld	ra,72(sp)
    80002a96:	6406                	ld	s0,64(sp)
    80002a98:	74e2                	ld	s1,56(sp)
    80002a9a:	7942                	ld	s2,48(sp)
    80002a9c:	79a2                	ld	s3,40(sp)
    80002a9e:	7a02                	ld	s4,32(sp)
    80002aa0:	6ae2                	ld	s5,24(sp)
    80002aa2:	6b42                	ld	s6,16(sp)
    80002aa4:	6ba2                	ld	s7,8(sp)
    80002aa6:	6161                	addi	sp,sp,80
    80002aa8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002aaa:	04000613          	li	a2,64
    80002aae:	4581                	li	a1,0
    80002ab0:	854e                	mv	a0,s3
    80002ab2:	ffffd097          	auipc	ra,0xffffd
    80002ab6:	6c6080e7          	jalr	1734(ra) # 80000178 <memset>
      dip->type = type;
    80002aba:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002abe:	854a                	mv	a0,s2
    80002ac0:	00001097          	auipc	ra,0x1
    80002ac4:	c84080e7          	jalr	-892(ra) # 80003744 <log_write>
      brelse(bp);
    80002ac8:	854a                	mv	a0,s2
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	9f6080e7          	jalr	-1546(ra) # 800024c0 <brelse>
      return iget(dev, inum);
    80002ad2:	85da                	mv	a1,s6
    80002ad4:	8556                	mv	a0,s5
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	d9c080e7          	jalr	-612(ra) # 80002872 <iget>
    80002ade:	bf5d                	j	80002a94 <ialloc+0x86>

0000000080002ae0 <iupdate>:
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	e426                	sd	s1,8(sp)
    80002ae8:	e04a                	sd	s2,0(sp)
    80002aea:	1000                	addi	s0,sp,32
    80002aec:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aee:	415c                	lw	a5,4(a0)
    80002af0:	0047d79b          	srliw	a5,a5,0x4
    80002af4:	00014597          	auipc	a1,0x14
    80002af8:	4cc5a583          	lw	a1,1228(a1) # 80016fc0 <sb+0x18>
    80002afc:	9dbd                	addw	a1,a1,a5
    80002afe:	4108                	lw	a0,0(a0)
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	890080e7          	jalr	-1904(ra) # 80002390 <bread>
    80002b08:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b0a:	05850793          	addi	a5,a0,88
    80002b0e:	40c8                	lw	a0,4(s1)
    80002b10:	893d                	andi	a0,a0,15
    80002b12:	051a                	slli	a0,a0,0x6
    80002b14:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b16:	04449703          	lh	a4,68(s1)
    80002b1a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b1e:	04649703          	lh	a4,70(s1)
    80002b22:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b26:	04849703          	lh	a4,72(s1)
    80002b2a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b2e:	04a49703          	lh	a4,74(s1)
    80002b32:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b36:	44f8                	lw	a4,76(s1)
    80002b38:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b3a:	03400613          	li	a2,52
    80002b3e:	05048593          	addi	a1,s1,80
    80002b42:	0531                	addi	a0,a0,12
    80002b44:	ffffd097          	auipc	ra,0xffffd
    80002b48:	694080e7          	jalr	1684(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00001097          	auipc	ra,0x1
    80002b52:	bf6080e7          	jalr	-1034(ra) # 80003744 <log_write>
  brelse(bp);
    80002b56:	854a                	mv	a0,s2
    80002b58:	00000097          	auipc	ra,0x0
    80002b5c:	968080e7          	jalr	-1688(ra) # 800024c0 <brelse>
}
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	64a2                	ld	s1,8(sp)
    80002b66:	6902                	ld	s2,0(sp)
    80002b68:	6105                	addi	sp,sp,32
    80002b6a:	8082                	ret

0000000080002b6c <idup>:
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b78:	00014517          	auipc	a0,0x14
    80002b7c:	45050513          	addi	a0,a0,1104 # 80016fc8 <itable>
    80002b80:	00003097          	auipc	ra,0x3
    80002b84:	66c080e7          	jalr	1644(ra) # 800061ec <acquire>
  ip->ref++;
    80002b88:	449c                	lw	a5,8(s1)
    80002b8a:	2785                	addiw	a5,a5,1
    80002b8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b8e:	00014517          	auipc	a0,0x14
    80002b92:	43a50513          	addi	a0,a0,1082 # 80016fc8 <itable>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	70a080e7          	jalr	1802(ra) # 800062a0 <release>
}
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6105                	addi	sp,sp,32
    80002ba8:	8082                	ret

0000000080002baa <ilock>:
{
    80002baa:	1101                	addi	sp,sp,-32
    80002bac:	ec06                	sd	ra,24(sp)
    80002bae:	e822                	sd	s0,16(sp)
    80002bb0:	e426                	sd	s1,8(sp)
    80002bb2:	e04a                	sd	s2,0(sp)
    80002bb4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bb6:	c115                	beqz	a0,80002bda <ilock+0x30>
    80002bb8:	84aa                	mv	s1,a0
    80002bba:	451c                	lw	a5,8(a0)
    80002bbc:	00f05f63          	blez	a5,80002bda <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bc0:	0541                	addi	a0,a0,16
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	ca2080e7          	jalr	-862(ra) # 80003864 <acquiresleep>
  if(ip->valid == 0){
    80002bca:	40bc                	lw	a5,64(s1)
    80002bcc:	cf99                	beqz	a5,80002bea <ilock+0x40>
}
    80002bce:	60e2                	ld	ra,24(sp)
    80002bd0:	6442                	ld	s0,16(sp)
    80002bd2:	64a2                	ld	s1,8(sp)
    80002bd4:	6902                	ld	s2,0(sp)
    80002bd6:	6105                	addi	sp,sp,32
    80002bd8:	8082                	ret
    panic("ilock");
    80002bda:	00006517          	auipc	a0,0x6
    80002bde:	b3e50513          	addi	a0,a0,-1218 # 80008718 <syscall_list+0x188>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	0c0080e7          	jalr	192(ra) # 80005ca2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bea:	40dc                	lw	a5,4(s1)
    80002bec:	0047d79b          	srliw	a5,a5,0x4
    80002bf0:	00014597          	auipc	a1,0x14
    80002bf4:	3d05a583          	lw	a1,976(a1) # 80016fc0 <sb+0x18>
    80002bf8:	9dbd                	addw	a1,a1,a5
    80002bfa:	4088                	lw	a0,0(s1)
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	794080e7          	jalr	1940(ra) # 80002390 <bread>
    80002c04:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c06:	05850593          	addi	a1,a0,88
    80002c0a:	40dc                	lw	a5,4(s1)
    80002c0c:	8bbd                	andi	a5,a5,15
    80002c0e:	079a                	slli	a5,a5,0x6
    80002c10:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c12:	00059783          	lh	a5,0(a1)
    80002c16:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c1a:	00259783          	lh	a5,2(a1)
    80002c1e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c22:	00459783          	lh	a5,4(a1)
    80002c26:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c2a:	00659783          	lh	a5,6(a1)
    80002c2e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c32:	459c                	lw	a5,8(a1)
    80002c34:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c36:	03400613          	li	a2,52
    80002c3a:	05b1                	addi	a1,a1,12
    80002c3c:	05048513          	addi	a0,s1,80
    80002c40:	ffffd097          	auipc	ra,0xffffd
    80002c44:	598080e7          	jalr	1432(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c48:	854a                	mv	a0,s2
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	876080e7          	jalr	-1930(ra) # 800024c0 <brelse>
    ip->valid = 1;
    80002c52:	4785                	li	a5,1
    80002c54:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c56:	04449783          	lh	a5,68(s1)
    80002c5a:	fbb5                	bnez	a5,80002bce <ilock+0x24>
      panic("ilock: no type");
    80002c5c:	00006517          	auipc	a0,0x6
    80002c60:	ac450513          	addi	a0,a0,-1340 # 80008720 <syscall_list+0x190>
    80002c64:	00003097          	auipc	ra,0x3
    80002c68:	03e080e7          	jalr	62(ra) # 80005ca2 <panic>

0000000080002c6c <iunlock>:
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	e04a                	sd	s2,0(sp)
    80002c76:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c78:	c905                	beqz	a0,80002ca8 <iunlock+0x3c>
    80002c7a:	84aa                	mv	s1,a0
    80002c7c:	01050913          	addi	s2,a0,16
    80002c80:	854a                	mv	a0,s2
    80002c82:	00001097          	auipc	ra,0x1
    80002c86:	c7c080e7          	jalr	-900(ra) # 800038fe <holdingsleep>
    80002c8a:	cd19                	beqz	a0,80002ca8 <iunlock+0x3c>
    80002c8c:	449c                	lw	a5,8(s1)
    80002c8e:	00f05d63          	blez	a5,80002ca8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c92:	854a                	mv	a0,s2
    80002c94:	00001097          	auipc	ra,0x1
    80002c98:	c26080e7          	jalr	-986(ra) # 800038ba <releasesleep>
}
    80002c9c:	60e2                	ld	ra,24(sp)
    80002c9e:	6442                	ld	s0,16(sp)
    80002ca0:	64a2                	ld	s1,8(sp)
    80002ca2:	6902                	ld	s2,0(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret
    panic("iunlock");
    80002ca8:	00006517          	auipc	a0,0x6
    80002cac:	a8850513          	addi	a0,a0,-1400 # 80008730 <syscall_list+0x1a0>
    80002cb0:	00003097          	auipc	ra,0x3
    80002cb4:	ff2080e7          	jalr	-14(ra) # 80005ca2 <panic>

0000000080002cb8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb8:	7179                	addi	sp,sp,-48
    80002cba:	f406                	sd	ra,40(sp)
    80002cbc:	f022                	sd	s0,32(sp)
    80002cbe:	ec26                	sd	s1,24(sp)
    80002cc0:	e84a                	sd	s2,16(sp)
    80002cc2:	e44e                	sd	s3,8(sp)
    80002cc4:	e052                	sd	s4,0(sp)
    80002cc6:	1800                	addi	s0,sp,48
    80002cc8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cca:	05050493          	addi	s1,a0,80
    80002cce:	08050913          	addi	s2,a0,128
    80002cd2:	a021                	j	80002cda <itrunc+0x22>
    80002cd4:	0491                	addi	s1,s1,4
    80002cd6:	01248d63          	beq	s1,s2,80002cf0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cda:	408c                	lw	a1,0(s1)
    80002cdc:	dde5                	beqz	a1,80002cd4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cde:	0009a503          	lw	a0,0(s3)
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	8f4080e7          	jalr	-1804(ra) # 800025d6 <bfree>
      ip->addrs[i] = 0;
    80002cea:	0004a023          	sw	zero,0(s1)
    80002cee:	b7dd                	j	80002cd4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cf0:	0809a583          	lw	a1,128(s3)
    80002cf4:	e185                	bnez	a1,80002d14 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cf6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cfa:	854e                	mv	a0,s3
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	de4080e7          	jalr	-540(ra) # 80002ae0 <iupdate>
}
    80002d04:	70a2                	ld	ra,40(sp)
    80002d06:	7402                	ld	s0,32(sp)
    80002d08:	64e2                	ld	s1,24(sp)
    80002d0a:	6942                	ld	s2,16(sp)
    80002d0c:	69a2                	ld	s3,8(sp)
    80002d0e:	6a02                	ld	s4,0(sp)
    80002d10:	6145                	addi	sp,sp,48
    80002d12:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d14:	0009a503          	lw	a0,0(s3)
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	678080e7          	jalr	1656(ra) # 80002390 <bread>
    80002d20:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d22:	05850493          	addi	s1,a0,88
    80002d26:	45850913          	addi	s2,a0,1112
    80002d2a:	a811                	j	80002d3e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d2c:	0009a503          	lw	a0,0(s3)
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	8a6080e7          	jalr	-1882(ra) # 800025d6 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d38:	0491                	addi	s1,s1,4
    80002d3a:	01248563          	beq	s1,s2,80002d44 <itrunc+0x8c>
      if(a[j])
    80002d3e:	408c                	lw	a1,0(s1)
    80002d40:	dde5                	beqz	a1,80002d38 <itrunc+0x80>
    80002d42:	b7ed                	j	80002d2c <itrunc+0x74>
    brelse(bp);
    80002d44:	8552                	mv	a0,s4
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	77a080e7          	jalr	1914(ra) # 800024c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d4e:	0809a583          	lw	a1,128(s3)
    80002d52:	0009a503          	lw	a0,0(s3)
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	880080e7          	jalr	-1920(ra) # 800025d6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d5e:	0809a023          	sw	zero,128(s3)
    80002d62:	bf51                	j	80002cf6 <itrunc+0x3e>

0000000080002d64 <iput>:
{
    80002d64:	1101                	addi	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	e426                	sd	s1,8(sp)
    80002d6c:	e04a                	sd	s2,0(sp)
    80002d6e:	1000                	addi	s0,sp,32
    80002d70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d72:	00014517          	auipc	a0,0x14
    80002d76:	25650513          	addi	a0,a0,598 # 80016fc8 <itable>
    80002d7a:	00003097          	auipc	ra,0x3
    80002d7e:	472080e7          	jalr	1138(ra) # 800061ec <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d82:	4498                	lw	a4,8(s1)
    80002d84:	4785                	li	a5,1
    80002d86:	02f70363          	beq	a4,a5,80002dac <iput+0x48>
  ip->ref--;
    80002d8a:	449c                	lw	a5,8(s1)
    80002d8c:	37fd                	addiw	a5,a5,-1
    80002d8e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d90:	00014517          	auipc	a0,0x14
    80002d94:	23850513          	addi	a0,a0,568 # 80016fc8 <itable>
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	508080e7          	jalr	1288(ra) # 800062a0 <release>
}
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	64a2                	ld	s1,8(sp)
    80002da6:	6902                	ld	s2,0(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dac:	40bc                	lw	a5,64(s1)
    80002dae:	dff1                	beqz	a5,80002d8a <iput+0x26>
    80002db0:	04a49783          	lh	a5,74(s1)
    80002db4:	fbf9                	bnez	a5,80002d8a <iput+0x26>
    acquiresleep(&ip->lock);
    80002db6:	01048913          	addi	s2,s1,16
    80002dba:	854a                	mv	a0,s2
    80002dbc:	00001097          	auipc	ra,0x1
    80002dc0:	aa8080e7          	jalr	-1368(ra) # 80003864 <acquiresleep>
    release(&itable.lock);
    80002dc4:	00014517          	auipc	a0,0x14
    80002dc8:	20450513          	addi	a0,a0,516 # 80016fc8 <itable>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	4d4080e7          	jalr	1236(ra) # 800062a0 <release>
    itrunc(ip);
    80002dd4:	8526                	mv	a0,s1
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	ee2080e7          	jalr	-286(ra) # 80002cb8 <itrunc>
    ip->type = 0;
    80002dde:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002de2:	8526                	mv	a0,s1
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	cfc080e7          	jalr	-772(ra) # 80002ae0 <iupdate>
    ip->valid = 0;
    80002dec:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002df0:	854a                	mv	a0,s2
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	ac8080e7          	jalr	-1336(ra) # 800038ba <releasesleep>
    acquire(&itable.lock);
    80002dfa:	00014517          	auipc	a0,0x14
    80002dfe:	1ce50513          	addi	a0,a0,462 # 80016fc8 <itable>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	3ea080e7          	jalr	1002(ra) # 800061ec <acquire>
    80002e0a:	b741                	j	80002d8a <iput+0x26>

0000000080002e0c <iunlockput>:
{
    80002e0c:	1101                	addi	sp,sp,-32
    80002e0e:	ec06                	sd	ra,24(sp)
    80002e10:	e822                	sd	s0,16(sp)
    80002e12:	e426                	sd	s1,8(sp)
    80002e14:	1000                	addi	s0,sp,32
    80002e16:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	e54080e7          	jalr	-428(ra) # 80002c6c <iunlock>
  iput(ip);
    80002e20:	8526                	mv	a0,s1
    80002e22:	00000097          	auipc	ra,0x0
    80002e26:	f42080e7          	jalr	-190(ra) # 80002d64 <iput>
}
    80002e2a:	60e2                	ld	ra,24(sp)
    80002e2c:	6442                	ld	s0,16(sp)
    80002e2e:	64a2                	ld	s1,8(sp)
    80002e30:	6105                	addi	sp,sp,32
    80002e32:	8082                	ret

0000000080002e34 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e34:	1141                	addi	sp,sp,-16
    80002e36:	e422                	sd	s0,8(sp)
    80002e38:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e3a:	411c                	lw	a5,0(a0)
    80002e3c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e3e:	415c                	lw	a5,4(a0)
    80002e40:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e42:	04451783          	lh	a5,68(a0)
    80002e46:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e4a:	04a51783          	lh	a5,74(a0)
    80002e4e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e52:	04c56783          	lwu	a5,76(a0)
    80002e56:	e99c                	sd	a5,16(a1)
}
    80002e58:	6422                	ld	s0,8(sp)
    80002e5a:	0141                	addi	sp,sp,16
    80002e5c:	8082                	ret

0000000080002e5e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e5e:	457c                	lw	a5,76(a0)
    80002e60:	0ed7e963          	bltu	a5,a3,80002f52 <readi+0xf4>
{
    80002e64:	7159                	addi	sp,sp,-112
    80002e66:	f486                	sd	ra,104(sp)
    80002e68:	f0a2                	sd	s0,96(sp)
    80002e6a:	eca6                	sd	s1,88(sp)
    80002e6c:	e8ca                	sd	s2,80(sp)
    80002e6e:	e4ce                	sd	s3,72(sp)
    80002e70:	e0d2                	sd	s4,64(sp)
    80002e72:	fc56                	sd	s5,56(sp)
    80002e74:	f85a                	sd	s6,48(sp)
    80002e76:	f45e                	sd	s7,40(sp)
    80002e78:	f062                	sd	s8,32(sp)
    80002e7a:	ec66                	sd	s9,24(sp)
    80002e7c:	e86a                	sd	s10,16(sp)
    80002e7e:	e46e                	sd	s11,8(sp)
    80002e80:	1880                	addi	s0,sp,112
    80002e82:	8b2a                	mv	s6,a0
    80002e84:	8bae                	mv	s7,a1
    80002e86:	8a32                	mv	s4,a2
    80002e88:	84b6                	mv	s1,a3
    80002e8a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e8c:	9f35                	addw	a4,a4,a3
    return 0;
    80002e8e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e90:	0ad76063          	bltu	a4,a3,80002f30 <readi+0xd2>
  if(off + n > ip->size)
    80002e94:	00e7f463          	bgeu	a5,a4,80002e9c <readi+0x3e>
    n = ip->size - off;
    80002e98:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e9c:	0a0a8963          	beqz	s5,80002f4e <readi+0xf0>
    80002ea0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ea6:	5c7d                	li	s8,-1
    80002ea8:	a82d                	j	80002ee2 <readi+0x84>
    80002eaa:	020d1d93          	slli	s11,s10,0x20
    80002eae:	020ddd93          	srli	s11,s11,0x20
    80002eb2:	05890613          	addi	a2,s2,88
    80002eb6:	86ee                	mv	a3,s11
    80002eb8:	963a                	add	a2,a2,a4
    80002eba:	85d2                	mv	a1,s4
    80002ebc:	855e                	mv	a0,s7
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	aaa080e7          	jalr	-1366(ra) # 80001968 <either_copyout>
    80002ec6:	05850d63          	beq	a0,s8,80002f20 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eca:	854a                	mv	a0,s2
    80002ecc:	fffff097          	auipc	ra,0xfffff
    80002ed0:	5f4080e7          	jalr	1524(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed4:	013d09bb          	addw	s3,s10,s3
    80002ed8:	009d04bb          	addw	s1,s10,s1
    80002edc:	9a6e                	add	s4,s4,s11
    80002ede:	0559f763          	bgeu	s3,s5,80002f2c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ee2:	00a4d59b          	srliw	a1,s1,0xa
    80002ee6:	855a                	mv	a0,s6
    80002ee8:	00000097          	auipc	ra,0x0
    80002eec:	8a2080e7          	jalr	-1886(ra) # 8000278a <bmap>
    80002ef0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ef4:	cd85                	beqz	a1,80002f2c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002ef6:	000b2503          	lw	a0,0(s6)
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	496080e7          	jalr	1174(ra) # 80002390 <bread>
    80002f02:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f04:	3ff4f713          	andi	a4,s1,1023
    80002f08:	40ec87bb          	subw	a5,s9,a4
    80002f0c:	413a86bb          	subw	a3,s5,s3
    80002f10:	8d3e                	mv	s10,a5
    80002f12:	2781                	sext.w	a5,a5
    80002f14:	0006861b          	sext.w	a2,a3
    80002f18:	f8f679e3          	bgeu	a2,a5,80002eaa <readi+0x4c>
    80002f1c:	8d36                	mv	s10,a3
    80002f1e:	b771                	j	80002eaa <readi+0x4c>
      brelse(bp);
    80002f20:	854a                	mv	a0,s2
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	59e080e7          	jalr	1438(ra) # 800024c0 <brelse>
      tot = -1;
    80002f2a:	59fd                	li	s3,-1
  }
  return tot;
    80002f2c:	0009851b          	sext.w	a0,s3
}
    80002f30:	70a6                	ld	ra,104(sp)
    80002f32:	7406                	ld	s0,96(sp)
    80002f34:	64e6                	ld	s1,88(sp)
    80002f36:	6946                	ld	s2,80(sp)
    80002f38:	69a6                	ld	s3,72(sp)
    80002f3a:	6a06                	ld	s4,64(sp)
    80002f3c:	7ae2                	ld	s5,56(sp)
    80002f3e:	7b42                	ld	s6,48(sp)
    80002f40:	7ba2                	ld	s7,40(sp)
    80002f42:	7c02                	ld	s8,32(sp)
    80002f44:	6ce2                	ld	s9,24(sp)
    80002f46:	6d42                	ld	s10,16(sp)
    80002f48:	6da2                	ld	s11,8(sp)
    80002f4a:	6165                	addi	sp,sp,112
    80002f4c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4e:	89d6                	mv	s3,s5
    80002f50:	bff1                	j	80002f2c <readi+0xce>
    return 0;
    80002f52:	4501                	li	a0,0
}
    80002f54:	8082                	ret

0000000080002f56 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f56:	457c                	lw	a5,76(a0)
    80002f58:	10d7e863          	bltu	a5,a3,80003068 <writei+0x112>
{
    80002f5c:	7159                	addi	sp,sp,-112
    80002f5e:	f486                	sd	ra,104(sp)
    80002f60:	f0a2                	sd	s0,96(sp)
    80002f62:	eca6                	sd	s1,88(sp)
    80002f64:	e8ca                	sd	s2,80(sp)
    80002f66:	e4ce                	sd	s3,72(sp)
    80002f68:	e0d2                	sd	s4,64(sp)
    80002f6a:	fc56                	sd	s5,56(sp)
    80002f6c:	f85a                	sd	s6,48(sp)
    80002f6e:	f45e                	sd	s7,40(sp)
    80002f70:	f062                	sd	s8,32(sp)
    80002f72:	ec66                	sd	s9,24(sp)
    80002f74:	e86a                	sd	s10,16(sp)
    80002f76:	e46e                	sd	s11,8(sp)
    80002f78:	1880                	addi	s0,sp,112
    80002f7a:	8aaa                	mv	s5,a0
    80002f7c:	8bae                	mv	s7,a1
    80002f7e:	8a32                	mv	s4,a2
    80002f80:	8936                	mv	s2,a3
    80002f82:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f84:	00e687bb          	addw	a5,a3,a4
    80002f88:	0ed7e263          	bltu	a5,a3,8000306c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f8c:	00043737          	lui	a4,0x43
    80002f90:	0ef76063          	bltu	a4,a5,80003070 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f94:	0c0b0863          	beqz	s6,80003064 <writei+0x10e>
    80002f98:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f9a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f9e:	5c7d                	li	s8,-1
    80002fa0:	a091                	j	80002fe4 <writei+0x8e>
    80002fa2:	020d1d93          	slli	s11,s10,0x20
    80002fa6:	020ddd93          	srli	s11,s11,0x20
    80002faa:	05848513          	addi	a0,s1,88
    80002fae:	86ee                	mv	a3,s11
    80002fb0:	8652                	mv	a2,s4
    80002fb2:	85de                	mv	a1,s7
    80002fb4:	953a                	add	a0,a0,a4
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	a08080e7          	jalr	-1528(ra) # 800019be <either_copyin>
    80002fbe:	07850263          	beq	a0,s8,80003022 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fc2:	8526                	mv	a0,s1
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	780080e7          	jalr	1920(ra) # 80003744 <log_write>
    brelse(bp);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	4f2080e7          	jalr	1266(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd6:	013d09bb          	addw	s3,s10,s3
    80002fda:	012d093b          	addw	s2,s10,s2
    80002fde:	9a6e                	add	s4,s4,s11
    80002fe0:	0569f663          	bgeu	s3,s6,8000302c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002fe4:	00a9559b          	srliw	a1,s2,0xa
    80002fe8:	8556                	mv	a0,s5
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	7a0080e7          	jalr	1952(ra) # 8000278a <bmap>
    80002ff2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ff6:	c99d                	beqz	a1,8000302c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002ff8:	000aa503          	lw	a0,0(s5)
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	394080e7          	jalr	916(ra) # 80002390 <bread>
    80003004:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003006:	3ff97713          	andi	a4,s2,1023
    8000300a:	40ec87bb          	subw	a5,s9,a4
    8000300e:	413b06bb          	subw	a3,s6,s3
    80003012:	8d3e                	mv	s10,a5
    80003014:	2781                	sext.w	a5,a5
    80003016:	0006861b          	sext.w	a2,a3
    8000301a:	f8f674e3          	bgeu	a2,a5,80002fa2 <writei+0x4c>
    8000301e:	8d36                	mv	s10,a3
    80003020:	b749                	j	80002fa2 <writei+0x4c>
      brelse(bp);
    80003022:	8526                	mv	a0,s1
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	49c080e7          	jalr	1180(ra) # 800024c0 <brelse>
  }

  if(off > ip->size)
    8000302c:	04caa783          	lw	a5,76(s5)
    80003030:	0127f463          	bgeu	a5,s2,80003038 <writei+0xe2>
    ip->size = off;
    80003034:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003038:	8556                	mv	a0,s5
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	aa6080e7          	jalr	-1370(ra) # 80002ae0 <iupdate>

  return tot;
    80003042:	0009851b          	sext.w	a0,s3
}
    80003046:	70a6                	ld	ra,104(sp)
    80003048:	7406                	ld	s0,96(sp)
    8000304a:	64e6                	ld	s1,88(sp)
    8000304c:	6946                	ld	s2,80(sp)
    8000304e:	69a6                	ld	s3,72(sp)
    80003050:	6a06                	ld	s4,64(sp)
    80003052:	7ae2                	ld	s5,56(sp)
    80003054:	7b42                	ld	s6,48(sp)
    80003056:	7ba2                	ld	s7,40(sp)
    80003058:	7c02                	ld	s8,32(sp)
    8000305a:	6ce2                	ld	s9,24(sp)
    8000305c:	6d42                	ld	s10,16(sp)
    8000305e:	6da2                	ld	s11,8(sp)
    80003060:	6165                	addi	sp,sp,112
    80003062:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003064:	89da                	mv	s3,s6
    80003066:	bfc9                	j	80003038 <writei+0xe2>
    return -1;
    80003068:	557d                	li	a0,-1
}
    8000306a:	8082                	ret
    return -1;
    8000306c:	557d                	li	a0,-1
    8000306e:	bfe1                	j	80003046 <writei+0xf0>
    return -1;
    80003070:	557d                	li	a0,-1
    80003072:	bfd1                	j	80003046 <writei+0xf0>

0000000080003074 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003074:	1141                	addi	sp,sp,-16
    80003076:	e406                	sd	ra,8(sp)
    80003078:	e022                	sd	s0,0(sp)
    8000307a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000307c:	4639                	li	a2,14
    8000307e:	ffffd097          	auipc	ra,0xffffd
    80003082:	1d2080e7          	jalr	466(ra) # 80000250 <strncmp>
}
    80003086:	60a2                	ld	ra,8(sp)
    80003088:	6402                	ld	s0,0(sp)
    8000308a:	0141                	addi	sp,sp,16
    8000308c:	8082                	ret

000000008000308e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000308e:	7139                	addi	sp,sp,-64
    80003090:	fc06                	sd	ra,56(sp)
    80003092:	f822                	sd	s0,48(sp)
    80003094:	f426                	sd	s1,40(sp)
    80003096:	f04a                	sd	s2,32(sp)
    80003098:	ec4e                	sd	s3,24(sp)
    8000309a:	e852                	sd	s4,16(sp)
    8000309c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000309e:	04451703          	lh	a4,68(a0)
    800030a2:	4785                	li	a5,1
    800030a4:	00f71a63          	bne	a4,a5,800030b8 <dirlookup+0x2a>
    800030a8:	892a                	mv	s2,a0
    800030aa:	89ae                	mv	s3,a1
    800030ac:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ae:	457c                	lw	a5,76(a0)
    800030b0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030b2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b4:	e79d                	bnez	a5,800030e2 <dirlookup+0x54>
    800030b6:	a8a5                	j	8000312e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030b8:	00005517          	auipc	a0,0x5
    800030bc:	68050513          	addi	a0,a0,1664 # 80008738 <syscall_list+0x1a8>
    800030c0:	00003097          	auipc	ra,0x3
    800030c4:	be2080e7          	jalr	-1054(ra) # 80005ca2 <panic>
      panic("dirlookup read");
    800030c8:	00005517          	auipc	a0,0x5
    800030cc:	68850513          	addi	a0,a0,1672 # 80008750 <syscall_list+0x1c0>
    800030d0:	00003097          	auipc	ra,0x3
    800030d4:	bd2080e7          	jalr	-1070(ra) # 80005ca2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d8:	24c1                	addiw	s1,s1,16
    800030da:	04c92783          	lw	a5,76(s2)
    800030de:	04f4f763          	bgeu	s1,a5,8000312c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030e2:	4741                	li	a4,16
    800030e4:	86a6                	mv	a3,s1
    800030e6:	fc040613          	addi	a2,s0,-64
    800030ea:	4581                	li	a1,0
    800030ec:	854a                	mv	a0,s2
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	d70080e7          	jalr	-656(ra) # 80002e5e <readi>
    800030f6:	47c1                	li	a5,16
    800030f8:	fcf518e3          	bne	a0,a5,800030c8 <dirlookup+0x3a>
    if(de.inum == 0)
    800030fc:	fc045783          	lhu	a5,-64(s0)
    80003100:	dfe1                	beqz	a5,800030d8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003102:	fc240593          	addi	a1,s0,-62
    80003106:	854e                	mv	a0,s3
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	f6c080e7          	jalr	-148(ra) # 80003074 <namecmp>
    80003110:	f561                	bnez	a0,800030d8 <dirlookup+0x4a>
      if(poff)
    80003112:	000a0463          	beqz	s4,8000311a <dirlookup+0x8c>
        *poff = off;
    80003116:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000311a:	fc045583          	lhu	a1,-64(s0)
    8000311e:	00092503          	lw	a0,0(s2)
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	750080e7          	jalr	1872(ra) # 80002872 <iget>
    8000312a:	a011                	j	8000312e <dirlookup+0xa0>
  return 0;
    8000312c:	4501                	li	a0,0
}
    8000312e:	70e2                	ld	ra,56(sp)
    80003130:	7442                	ld	s0,48(sp)
    80003132:	74a2                	ld	s1,40(sp)
    80003134:	7902                	ld	s2,32(sp)
    80003136:	69e2                	ld	s3,24(sp)
    80003138:	6a42                	ld	s4,16(sp)
    8000313a:	6121                	addi	sp,sp,64
    8000313c:	8082                	ret

000000008000313e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000313e:	711d                	addi	sp,sp,-96
    80003140:	ec86                	sd	ra,88(sp)
    80003142:	e8a2                	sd	s0,80(sp)
    80003144:	e4a6                	sd	s1,72(sp)
    80003146:	e0ca                	sd	s2,64(sp)
    80003148:	fc4e                	sd	s3,56(sp)
    8000314a:	f852                	sd	s4,48(sp)
    8000314c:	f456                	sd	s5,40(sp)
    8000314e:	f05a                	sd	s6,32(sp)
    80003150:	ec5e                	sd	s7,24(sp)
    80003152:	e862                	sd	s8,16(sp)
    80003154:	e466                	sd	s9,8(sp)
    80003156:	1080                	addi	s0,sp,96
    80003158:	84aa                	mv	s1,a0
    8000315a:	8b2e                	mv	s6,a1
    8000315c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000315e:	00054703          	lbu	a4,0(a0)
    80003162:	02f00793          	li	a5,47
    80003166:	02f70363          	beq	a4,a5,8000318c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000316a:	ffffe097          	auipc	ra,0xffffe
    8000316e:	d46080e7          	jalr	-698(ra) # 80000eb0 <myproc>
    80003172:	15053503          	ld	a0,336(a0)
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	9f6080e7          	jalr	-1546(ra) # 80002b6c <idup>
    8000317e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003180:	02f00913          	li	s2,47
  len = path - s;
    80003184:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003186:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003188:	4c05                	li	s8,1
    8000318a:	a865                	j	80003242 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000318c:	4585                	li	a1,1
    8000318e:	4505                	li	a0,1
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	6e2080e7          	jalr	1762(ra) # 80002872 <iget>
    80003198:	89aa                	mv	s3,a0
    8000319a:	b7dd                	j	80003180 <namex+0x42>
      iunlockput(ip);
    8000319c:	854e                	mv	a0,s3
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	c6e080e7          	jalr	-914(ra) # 80002e0c <iunlockput>
      return 0;
    800031a6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031a8:	854e                	mv	a0,s3
    800031aa:	60e6                	ld	ra,88(sp)
    800031ac:	6446                	ld	s0,80(sp)
    800031ae:	64a6                	ld	s1,72(sp)
    800031b0:	6906                	ld	s2,64(sp)
    800031b2:	79e2                	ld	s3,56(sp)
    800031b4:	7a42                	ld	s4,48(sp)
    800031b6:	7aa2                	ld	s5,40(sp)
    800031b8:	7b02                	ld	s6,32(sp)
    800031ba:	6be2                	ld	s7,24(sp)
    800031bc:	6c42                	ld	s8,16(sp)
    800031be:	6ca2                	ld	s9,8(sp)
    800031c0:	6125                	addi	sp,sp,96
    800031c2:	8082                	ret
      iunlock(ip);
    800031c4:	854e                	mv	a0,s3
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	aa6080e7          	jalr	-1370(ra) # 80002c6c <iunlock>
      return ip;
    800031ce:	bfe9                	j	800031a8 <namex+0x6a>
      iunlockput(ip);
    800031d0:	854e                	mv	a0,s3
    800031d2:	00000097          	auipc	ra,0x0
    800031d6:	c3a080e7          	jalr	-966(ra) # 80002e0c <iunlockput>
      return 0;
    800031da:	89d2                	mv	s3,s4
    800031dc:	b7f1                	j	800031a8 <namex+0x6a>
  len = path - s;
    800031de:	40b48633          	sub	a2,s1,a1
    800031e2:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031e6:	094cd463          	bge	s9,s4,8000326e <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031ea:	4639                	li	a2,14
    800031ec:	8556                	mv	a0,s5
    800031ee:	ffffd097          	auipc	ra,0xffffd
    800031f2:	fea080e7          	jalr	-22(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031f6:	0004c783          	lbu	a5,0(s1)
    800031fa:	01279763          	bne	a5,s2,80003208 <namex+0xca>
    path++;
    800031fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003200:	0004c783          	lbu	a5,0(s1)
    80003204:	ff278de3          	beq	a5,s2,800031fe <namex+0xc0>
    ilock(ip);
    80003208:	854e                	mv	a0,s3
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	9a0080e7          	jalr	-1632(ra) # 80002baa <ilock>
    if(ip->type != T_DIR){
    80003212:	04499783          	lh	a5,68(s3)
    80003216:	f98793e3          	bne	a5,s8,8000319c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000321a:	000b0563          	beqz	s6,80003224 <namex+0xe6>
    8000321e:	0004c783          	lbu	a5,0(s1)
    80003222:	d3cd                	beqz	a5,800031c4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003224:	865e                	mv	a2,s7
    80003226:	85d6                	mv	a1,s5
    80003228:	854e                	mv	a0,s3
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	e64080e7          	jalr	-412(ra) # 8000308e <dirlookup>
    80003232:	8a2a                	mv	s4,a0
    80003234:	dd51                	beqz	a0,800031d0 <namex+0x92>
    iunlockput(ip);
    80003236:	854e                	mv	a0,s3
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	bd4080e7          	jalr	-1068(ra) # 80002e0c <iunlockput>
    ip = next;
    80003240:	89d2                	mv	s3,s4
  while(*path == '/')
    80003242:	0004c783          	lbu	a5,0(s1)
    80003246:	05279763          	bne	a5,s2,80003294 <namex+0x156>
    path++;
    8000324a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324c:	0004c783          	lbu	a5,0(s1)
    80003250:	ff278de3          	beq	a5,s2,8000324a <namex+0x10c>
  if(*path == 0)
    80003254:	c79d                	beqz	a5,80003282 <namex+0x144>
    path++;
    80003256:	85a6                	mv	a1,s1
  len = path - s;
    80003258:	8a5e                	mv	s4,s7
    8000325a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000325c:	01278963          	beq	a5,s2,8000326e <namex+0x130>
    80003260:	dfbd                	beqz	a5,800031de <namex+0xa0>
    path++;
    80003262:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	ff279ce3          	bne	a5,s2,80003260 <namex+0x122>
    8000326c:	bf8d                	j	800031de <namex+0xa0>
    memmove(name, s, len);
    8000326e:	2601                	sext.w	a2,a2
    80003270:	8556                	mv	a0,s5
    80003272:	ffffd097          	auipc	ra,0xffffd
    80003276:	f66080e7          	jalr	-154(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000327a:	9a56                	add	s4,s4,s5
    8000327c:	000a0023          	sb	zero,0(s4)
    80003280:	bf9d                	j	800031f6 <namex+0xb8>
  if(nameiparent){
    80003282:	f20b03e3          	beqz	s6,800031a8 <namex+0x6a>
    iput(ip);
    80003286:	854e                	mv	a0,s3
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	adc080e7          	jalr	-1316(ra) # 80002d64 <iput>
    return 0;
    80003290:	4981                	li	s3,0
    80003292:	bf19                	j	800031a8 <namex+0x6a>
  if(*path == 0)
    80003294:	d7fd                	beqz	a5,80003282 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	85a6                	mv	a1,s1
    8000329c:	b7d1                	j	80003260 <namex+0x122>

000000008000329e <dirlink>:
{
    8000329e:	7139                	addi	sp,sp,-64
    800032a0:	fc06                	sd	ra,56(sp)
    800032a2:	f822                	sd	s0,48(sp)
    800032a4:	f426                	sd	s1,40(sp)
    800032a6:	f04a                	sd	s2,32(sp)
    800032a8:	ec4e                	sd	s3,24(sp)
    800032aa:	e852                	sd	s4,16(sp)
    800032ac:	0080                	addi	s0,sp,64
    800032ae:	892a                	mv	s2,a0
    800032b0:	8a2e                	mv	s4,a1
    800032b2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032b4:	4601                	li	a2,0
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	dd8080e7          	jalr	-552(ra) # 8000308e <dirlookup>
    800032be:	e93d                	bnez	a0,80003334 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c0:	04c92483          	lw	s1,76(s2)
    800032c4:	c49d                	beqz	s1,800032f2 <dirlink+0x54>
    800032c6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c8:	4741                	li	a4,16
    800032ca:	86a6                	mv	a3,s1
    800032cc:	fc040613          	addi	a2,s0,-64
    800032d0:	4581                	li	a1,0
    800032d2:	854a                	mv	a0,s2
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	b8a080e7          	jalr	-1142(ra) # 80002e5e <readi>
    800032dc:	47c1                	li	a5,16
    800032de:	06f51163          	bne	a0,a5,80003340 <dirlink+0xa2>
    if(de.inum == 0)
    800032e2:	fc045783          	lhu	a5,-64(s0)
    800032e6:	c791                	beqz	a5,800032f2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e8:	24c1                	addiw	s1,s1,16
    800032ea:	04c92783          	lw	a5,76(s2)
    800032ee:	fcf4ede3          	bltu	s1,a5,800032c8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032f2:	4639                	li	a2,14
    800032f4:	85d2                	mv	a1,s4
    800032f6:	fc240513          	addi	a0,s0,-62
    800032fa:	ffffd097          	auipc	ra,0xffffd
    800032fe:	f92080e7          	jalr	-110(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003302:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003306:	4741                	li	a4,16
    80003308:	86a6                	mv	a3,s1
    8000330a:	fc040613          	addi	a2,s0,-64
    8000330e:	4581                	li	a1,0
    80003310:	854a                	mv	a0,s2
    80003312:	00000097          	auipc	ra,0x0
    80003316:	c44080e7          	jalr	-956(ra) # 80002f56 <writei>
    8000331a:	1541                	addi	a0,a0,-16
    8000331c:	00a03533          	snez	a0,a0
    80003320:	40a00533          	neg	a0,a0
}
    80003324:	70e2                	ld	ra,56(sp)
    80003326:	7442                	ld	s0,48(sp)
    80003328:	74a2                	ld	s1,40(sp)
    8000332a:	7902                	ld	s2,32(sp)
    8000332c:	69e2                	ld	s3,24(sp)
    8000332e:	6a42                	ld	s4,16(sp)
    80003330:	6121                	addi	sp,sp,64
    80003332:	8082                	ret
    iput(ip);
    80003334:	00000097          	auipc	ra,0x0
    80003338:	a30080e7          	jalr	-1488(ra) # 80002d64 <iput>
    return -1;
    8000333c:	557d                	li	a0,-1
    8000333e:	b7dd                	j	80003324 <dirlink+0x86>
      panic("dirlink read");
    80003340:	00005517          	auipc	a0,0x5
    80003344:	42050513          	addi	a0,a0,1056 # 80008760 <syscall_list+0x1d0>
    80003348:	00003097          	auipc	ra,0x3
    8000334c:	95a080e7          	jalr	-1702(ra) # 80005ca2 <panic>

0000000080003350 <namei>:

struct inode*
namei(char *path)
{
    80003350:	1101                	addi	sp,sp,-32
    80003352:	ec06                	sd	ra,24(sp)
    80003354:	e822                	sd	s0,16(sp)
    80003356:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003358:	fe040613          	addi	a2,s0,-32
    8000335c:	4581                	li	a1,0
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	de0080e7          	jalr	-544(ra) # 8000313e <namex>
}
    80003366:	60e2                	ld	ra,24(sp)
    80003368:	6442                	ld	s0,16(sp)
    8000336a:	6105                	addi	sp,sp,32
    8000336c:	8082                	ret

000000008000336e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000336e:	1141                	addi	sp,sp,-16
    80003370:	e406                	sd	ra,8(sp)
    80003372:	e022                	sd	s0,0(sp)
    80003374:	0800                	addi	s0,sp,16
    80003376:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003378:	4585                	li	a1,1
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	dc4080e7          	jalr	-572(ra) # 8000313e <namex>
}
    80003382:	60a2                	ld	ra,8(sp)
    80003384:	6402                	ld	s0,0(sp)
    80003386:	0141                	addi	sp,sp,16
    80003388:	8082                	ret

000000008000338a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	e426                	sd	s1,8(sp)
    80003392:	e04a                	sd	s2,0(sp)
    80003394:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003396:	00015917          	auipc	s2,0x15
    8000339a:	6da90913          	addi	s2,s2,1754 # 80018a70 <log>
    8000339e:	01892583          	lw	a1,24(s2)
    800033a2:	02892503          	lw	a0,40(s2)
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	fea080e7          	jalr	-22(ra) # 80002390 <bread>
    800033ae:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033b0:	02c92683          	lw	a3,44(s2)
    800033b4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033b6:	02d05763          	blez	a3,800033e4 <write_head+0x5a>
    800033ba:	00015797          	auipc	a5,0x15
    800033be:	6e678793          	addi	a5,a5,1766 # 80018aa0 <log+0x30>
    800033c2:	05c50713          	addi	a4,a0,92
    800033c6:	36fd                	addiw	a3,a3,-1
    800033c8:	1682                	slli	a3,a3,0x20
    800033ca:	9281                	srli	a3,a3,0x20
    800033cc:	068a                	slli	a3,a3,0x2
    800033ce:	00015617          	auipc	a2,0x15
    800033d2:	6d660613          	addi	a2,a2,1750 # 80018aa4 <log+0x34>
    800033d6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033d8:	4390                	lw	a2,0(a5)
    800033da:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033dc:	0791                	addi	a5,a5,4
    800033de:	0711                	addi	a4,a4,4
    800033e0:	fed79ce3          	bne	a5,a3,800033d8 <write_head+0x4e>
  }
  bwrite(buf);
    800033e4:	8526                	mv	a0,s1
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	09c080e7          	jalr	156(ra) # 80002482 <bwrite>
  brelse(buf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	0d0080e7          	jalr	208(ra) # 800024c0 <brelse>
}
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	64a2                	ld	s1,8(sp)
    800033fe:	6902                	ld	s2,0(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret

0000000080003404 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003404:	00015797          	auipc	a5,0x15
    80003408:	6987a783          	lw	a5,1688(a5) # 80018a9c <log+0x2c>
    8000340c:	0af05d63          	blez	a5,800034c6 <install_trans+0xc2>
{
    80003410:	7139                	addi	sp,sp,-64
    80003412:	fc06                	sd	ra,56(sp)
    80003414:	f822                	sd	s0,48(sp)
    80003416:	f426                	sd	s1,40(sp)
    80003418:	f04a                	sd	s2,32(sp)
    8000341a:	ec4e                	sd	s3,24(sp)
    8000341c:	e852                	sd	s4,16(sp)
    8000341e:	e456                	sd	s5,8(sp)
    80003420:	e05a                	sd	s6,0(sp)
    80003422:	0080                	addi	s0,sp,64
    80003424:	8b2a                	mv	s6,a0
    80003426:	00015a97          	auipc	s5,0x15
    8000342a:	67aa8a93          	addi	s5,s5,1658 # 80018aa0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003430:	00015997          	auipc	s3,0x15
    80003434:	64098993          	addi	s3,s3,1600 # 80018a70 <log>
    80003438:	a035                	j	80003464 <install_trans+0x60>
      bunpin(dbuf);
    8000343a:	8526                	mv	a0,s1
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	15e080e7          	jalr	350(ra) # 8000259a <bunpin>
    brelse(lbuf);
    80003444:	854a                	mv	a0,s2
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	07a080e7          	jalr	122(ra) # 800024c0 <brelse>
    brelse(dbuf);
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	070080e7          	jalr	112(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	2a05                	addiw	s4,s4,1
    8000345a:	0a91                	addi	s5,s5,4
    8000345c:	02c9a783          	lw	a5,44(s3)
    80003460:	04fa5963          	bge	s4,a5,800034b2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003464:	0189a583          	lw	a1,24(s3)
    80003468:	014585bb          	addw	a1,a1,s4
    8000346c:	2585                	addiw	a1,a1,1
    8000346e:	0289a503          	lw	a0,40(s3)
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	f1e080e7          	jalr	-226(ra) # 80002390 <bread>
    8000347a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000347c:	000aa583          	lw	a1,0(s5)
    80003480:	0289a503          	lw	a0,40(s3)
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	f0c080e7          	jalr	-244(ra) # 80002390 <bread>
    8000348c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000348e:	40000613          	li	a2,1024
    80003492:	05890593          	addi	a1,s2,88
    80003496:	05850513          	addi	a0,a0,88
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	d3e080e7          	jalr	-706(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a2:	8526                	mv	a0,s1
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	fde080e7          	jalr	-34(ra) # 80002482 <bwrite>
    if(recovering == 0)
    800034ac:	f80b1ce3          	bnez	s6,80003444 <install_trans+0x40>
    800034b0:	b769                	j	8000343a <install_trans+0x36>
}
    800034b2:	70e2                	ld	ra,56(sp)
    800034b4:	7442                	ld	s0,48(sp)
    800034b6:	74a2                	ld	s1,40(sp)
    800034b8:	7902                	ld	s2,32(sp)
    800034ba:	69e2                	ld	s3,24(sp)
    800034bc:	6a42                	ld	s4,16(sp)
    800034be:	6aa2                	ld	s5,8(sp)
    800034c0:	6b02                	ld	s6,0(sp)
    800034c2:	6121                	addi	sp,sp,64
    800034c4:	8082                	ret
    800034c6:	8082                	ret

00000000800034c8 <initlog>:
{
    800034c8:	7179                	addi	sp,sp,-48
    800034ca:	f406                	sd	ra,40(sp)
    800034cc:	f022                	sd	s0,32(sp)
    800034ce:	ec26                	sd	s1,24(sp)
    800034d0:	e84a                	sd	s2,16(sp)
    800034d2:	e44e                	sd	s3,8(sp)
    800034d4:	1800                	addi	s0,sp,48
    800034d6:	892a                	mv	s2,a0
    800034d8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034da:	00015497          	auipc	s1,0x15
    800034de:	59648493          	addi	s1,s1,1430 # 80018a70 <log>
    800034e2:	00005597          	auipc	a1,0x5
    800034e6:	28e58593          	addi	a1,a1,654 # 80008770 <syscall_list+0x1e0>
    800034ea:	8526                	mv	a0,s1
    800034ec:	00003097          	auipc	ra,0x3
    800034f0:	c70080e7          	jalr	-912(ra) # 8000615c <initlock>
  log.start = sb->logstart;
    800034f4:	0149a583          	lw	a1,20(s3)
    800034f8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034fa:	0109a783          	lw	a5,16(s3)
    800034fe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003500:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003504:	854a                	mv	a0,s2
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	e8a080e7          	jalr	-374(ra) # 80002390 <bread>
  log.lh.n = lh->n;
    8000350e:	4d3c                	lw	a5,88(a0)
    80003510:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003512:	02f05563          	blez	a5,8000353c <initlog+0x74>
    80003516:	05c50713          	addi	a4,a0,92
    8000351a:	00015697          	auipc	a3,0x15
    8000351e:	58668693          	addi	a3,a3,1414 # 80018aa0 <log+0x30>
    80003522:	37fd                	addiw	a5,a5,-1
    80003524:	1782                	slli	a5,a5,0x20
    80003526:	9381                	srli	a5,a5,0x20
    80003528:	078a                	slli	a5,a5,0x2
    8000352a:	06050613          	addi	a2,a0,96
    8000352e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003530:	4310                	lw	a2,0(a4)
    80003532:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003534:	0711                	addi	a4,a4,4
    80003536:	0691                	addi	a3,a3,4
    80003538:	fef71ce3          	bne	a4,a5,80003530 <initlog+0x68>
  brelse(buf);
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	f84080e7          	jalr	-124(ra) # 800024c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003544:	4505                	li	a0,1
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	ebe080e7          	jalr	-322(ra) # 80003404 <install_trans>
  log.lh.n = 0;
    8000354e:	00015797          	auipc	a5,0x15
    80003552:	5407a723          	sw	zero,1358(a5) # 80018a9c <log+0x2c>
  write_head(); // clear the log
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	e34080e7          	jalr	-460(ra) # 8000338a <write_head>
}
    8000355e:	70a2                	ld	ra,40(sp)
    80003560:	7402                	ld	s0,32(sp)
    80003562:	64e2                	ld	s1,24(sp)
    80003564:	6942                	ld	s2,16(sp)
    80003566:	69a2                	ld	s3,8(sp)
    80003568:	6145                	addi	sp,sp,48
    8000356a:	8082                	ret

000000008000356c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	e426                	sd	s1,8(sp)
    80003574:	e04a                	sd	s2,0(sp)
    80003576:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003578:	00015517          	auipc	a0,0x15
    8000357c:	4f850513          	addi	a0,a0,1272 # 80018a70 <log>
    80003580:	00003097          	auipc	ra,0x3
    80003584:	c6c080e7          	jalr	-916(ra) # 800061ec <acquire>
  while(1){
    if(log.committing){
    80003588:	00015497          	auipc	s1,0x15
    8000358c:	4e848493          	addi	s1,s1,1256 # 80018a70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003590:	4979                	li	s2,30
    80003592:	a039                	j	800035a0 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003594:	85a6                	mv	a1,s1
    80003596:	8526                	mv	a0,s1
    80003598:	ffffe097          	auipc	ra,0xffffe
    8000359c:	fc8080e7          	jalr	-56(ra) # 80001560 <sleep>
    if(log.committing){
    800035a0:	50dc                	lw	a5,36(s1)
    800035a2:	fbed                	bnez	a5,80003594 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a4:	509c                	lw	a5,32(s1)
    800035a6:	0017871b          	addiw	a4,a5,1
    800035aa:	0007069b          	sext.w	a3,a4
    800035ae:	0027179b          	slliw	a5,a4,0x2
    800035b2:	9fb9                	addw	a5,a5,a4
    800035b4:	0017979b          	slliw	a5,a5,0x1
    800035b8:	54d8                	lw	a4,44(s1)
    800035ba:	9fb9                	addw	a5,a5,a4
    800035bc:	00f95963          	bge	s2,a5,800035ce <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035c0:	85a6                	mv	a1,s1
    800035c2:	8526                	mv	a0,s1
    800035c4:	ffffe097          	auipc	ra,0xffffe
    800035c8:	f9c080e7          	jalr	-100(ra) # 80001560 <sleep>
    800035cc:	bfd1                	j	800035a0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ce:	00015517          	auipc	a0,0x15
    800035d2:	4a250513          	addi	a0,a0,1186 # 80018a70 <log>
    800035d6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035d8:	00003097          	auipc	ra,0x3
    800035dc:	cc8080e7          	jalr	-824(ra) # 800062a0 <release>
      break;
    }
  }
}
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	64a2                	ld	s1,8(sp)
    800035e6:	6902                	ld	s2,0(sp)
    800035e8:	6105                	addi	sp,sp,32
    800035ea:	8082                	ret

00000000800035ec <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035ec:	7139                	addi	sp,sp,-64
    800035ee:	fc06                	sd	ra,56(sp)
    800035f0:	f822                	sd	s0,48(sp)
    800035f2:	f426                	sd	s1,40(sp)
    800035f4:	f04a                	sd	s2,32(sp)
    800035f6:	ec4e                	sd	s3,24(sp)
    800035f8:	e852                	sd	s4,16(sp)
    800035fa:	e456                	sd	s5,8(sp)
    800035fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035fe:	00015497          	auipc	s1,0x15
    80003602:	47248493          	addi	s1,s1,1138 # 80018a70 <log>
    80003606:	8526                	mv	a0,s1
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	be4080e7          	jalr	-1052(ra) # 800061ec <acquire>
  log.outstanding -= 1;
    80003610:	509c                	lw	a5,32(s1)
    80003612:	37fd                	addiw	a5,a5,-1
    80003614:	0007891b          	sext.w	s2,a5
    80003618:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000361a:	50dc                	lw	a5,36(s1)
    8000361c:	efb9                	bnez	a5,8000367a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000361e:	06091663          	bnez	s2,8000368a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003622:	00015497          	auipc	s1,0x15
    80003626:	44e48493          	addi	s1,s1,1102 # 80018a70 <log>
    8000362a:	4785                	li	a5,1
    8000362c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000362e:	8526                	mv	a0,s1
    80003630:	00003097          	auipc	ra,0x3
    80003634:	c70080e7          	jalr	-912(ra) # 800062a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003638:	54dc                	lw	a5,44(s1)
    8000363a:	06f04763          	bgtz	a5,800036a8 <end_op+0xbc>
    acquire(&log.lock);
    8000363e:	00015497          	auipc	s1,0x15
    80003642:	43248493          	addi	s1,s1,1074 # 80018a70 <log>
    80003646:	8526                	mv	a0,s1
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	ba4080e7          	jalr	-1116(ra) # 800061ec <acquire>
    log.committing = 0;
    80003650:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003654:	8526                	mv	a0,s1
    80003656:	ffffe097          	auipc	ra,0xffffe
    8000365a:	f6e080e7          	jalr	-146(ra) # 800015c4 <wakeup>
    release(&log.lock);
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	c40080e7          	jalr	-960(ra) # 800062a0 <release>
}
    80003668:	70e2                	ld	ra,56(sp)
    8000366a:	7442                	ld	s0,48(sp)
    8000366c:	74a2                	ld	s1,40(sp)
    8000366e:	7902                	ld	s2,32(sp)
    80003670:	69e2                	ld	s3,24(sp)
    80003672:	6a42                	ld	s4,16(sp)
    80003674:	6aa2                	ld	s5,8(sp)
    80003676:	6121                	addi	sp,sp,64
    80003678:	8082                	ret
    panic("log.committing");
    8000367a:	00005517          	auipc	a0,0x5
    8000367e:	0fe50513          	addi	a0,a0,254 # 80008778 <syscall_list+0x1e8>
    80003682:	00002097          	auipc	ra,0x2
    80003686:	620080e7          	jalr	1568(ra) # 80005ca2 <panic>
    wakeup(&log);
    8000368a:	00015497          	auipc	s1,0x15
    8000368e:	3e648493          	addi	s1,s1,998 # 80018a70 <log>
    80003692:	8526                	mv	a0,s1
    80003694:	ffffe097          	auipc	ra,0xffffe
    80003698:	f30080e7          	jalr	-208(ra) # 800015c4 <wakeup>
  release(&log.lock);
    8000369c:	8526                	mv	a0,s1
    8000369e:	00003097          	auipc	ra,0x3
    800036a2:	c02080e7          	jalr	-1022(ra) # 800062a0 <release>
  if(do_commit){
    800036a6:	b7c9                	j	80003668 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	00015a97          	auipc	s5,0x15
    800036ac:	3f8a8a93          	addi	s5,s5,1016 # 80018aa0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036b0:	00015a17          	auipc	s4,0x15
    800036b4:	3c0a0a13          	addi	s4,s4,960 # 80018a70 <log>
    800036b8:	018a2583          	lw	a1,24(s4)
    800036bc:	012585bb          	addw	a1,a1,s2
    800036c0:	2585                	addiw	a1,a1,1
    800036c2:	028a2503          	lw	a0,40(s4)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	cca080e7          	jalr	-822(ra) # 80002390 <bread>
    800036ce:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036d0:	000aa583          	lw	a1,0(s5)
    800036d4:	028a2503          	lw	a0,40(s4)
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	cb8080e7          	jalr	-840(ra) # 80002390 <bread>
    800036e0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036e2:	40000613          	li	a2,1024
    800036e6:	05850593          	addi	a1,a0,88
    800036ea:	05848513          	addi	a0,s1,88
    800036ee:	ffffd097          	auipc	ra,0xffffd
    800036f2:	aea080e7          	jalr	-1302(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	d8a080e7          	jalr	-630(ra) # 80002482 <bwrite>
    brelse(from);
    80003700:	854e                	mv	a0,s3
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	dbe080e7          	jalr	-578(ra) # 800024c0 <brelse>
    brelse(to);
    8000370a:	8526                	mv	a0,s1
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	db4080e7          	jalr	-588(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003714:	2905                	addiw	s2,s2,1
    80003716:	0a91                	addi	s5,s5,4
    80003718:	02ca2783          	lw	a5,44(s4)
    8000371c:	f8f94ee3          	blt	s2,a5,800036b8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003720:	00000097          	auipc	ra,0x0
    80003724:	c6a080e7          	jalr	-918(ra) # 8000338a <write_head>
    install_trans(0); // Now install writes to home locations
    80003728:	4501                	li	a0,0
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	cda080e7          	jalr	-806(ra) # 80003404 <install_trans>
    log.lh.n = 0;
    80003732:	00015797          	auipc	a5,0x15
    80003736:	3607a523          	sw	zero,874(a5) # 80018a9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	c50080e7          	jalr	-944(ra) # 8000338a <write_head>
    80003742:	bdf5                	j	8000363e <end_op+0x52>

0000000080003744 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	e426                	sd	s1,8(sp)
    8000374c:	e04a                	sd	s2,0(sp)
    8000374e:	1000                	addi	s0,sp,32
    80003750:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003752:	00015917          	auipc	s2,0x15
    80003756:	31e90913          	addi	s2,s2,798 # 80018a70 <log>
    8000375a:	854a                	mv	a0,s2
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	a90080e7          	jalr	-1392(ra) # 800061ec <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003764:	02c92603          	lw	a2,44(s2)
    80003768:	47f5                	li	a5,29
    8000376a:	06c7c563          	blt	a5,a2,800037d4 <log_write+0x90>
    8000376e:	00015797          	auipc	a5,0x15
    80003772:	31e7a783          	lw	a5,798(a5) # 80018a8c <log+0x1c>
    80003776:	37fd                	addiw	a5,a5,-1
    80003778:	04f65e63          	bge	a2,a5,800037d4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000377c:	00015797          	auipc	a5,0x15
    80003780:	3147a783          	lw	a5,788(a5) # 80018a90 <log+0x20>
    80003784:	06f05063          	blez	a5,800037e4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003788:	4781                	li	a5,0
    8000378a:	06c05563          	blez	a2,800037f4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378e:	44cc                	lw	a1,12(s1)
    80003790:	00015717          	auipc	a4,0x15
    80003794:	31070713          	addi	a4,a4,784 # 80018aa0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003798:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379a:	4314                	lw	a3,0(a4)
    8000379c:	04b68c63          	beq	a3,a1,800037f4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037a0:	2785                	addiw	a5,a5,1
    800037a2:	0711                	addi	a4,a4,4
    800037a4:	fef61be3          	bne	a2,a5,8000379a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a8:	0621                	addi	a2,a2,8
    800037aa:	060a                	slli	a2,a2,0x2
    800037ac:	00015797          	auipc	a5,0x15
    800037b0:	2c478793          	addi	a5,a5,708 # 80018a70 <log>
    800037b4:	963e                	add	a2,a2,a5
    800037b6:	44dc                	lw	a5,12(s1)
    800037b8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ba:	8526                	mv	a0,s1
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	da2080e7          	jalr	-606(ra) # 8000255e <bpin>
    log.lh.n++;
    800037c4:	00015717          	auipc	a4,0x15
    800037c8:	2ac70713          	addi	a4,a4,684 # 80018a70 <log>
    800037cc:	575c                	lw	a5,44(a4)
    800037ce:	2785                	addiw	a5,a5,1
    800037d0:	d75c                	sw	a5,44(a4)
    800037d2:	a835                	j	8000380e <log_write+0xca>
    panic("too big a transaction");
    800037d4:	00005517          	auipc	a0,0x5
    800037d8:	fb450513          	addi	a0,a0,-76 # 80008788 <syscall_list+0x1f8>
    800037dc:	00002097          	auipc	ra,0x2
    800037e0:	4c6080e7          	jalr	1222(ra) # 80005ca2 <panic>
    panic("log_write outside of trans");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	fbc50513          	addi	a0,a0,-68 # 800087a0 <syscall_list+0x210>
    800037ec:	00002097          	auipc	ra,0x2
    800037f0:	4b6080e7          	jalr	1206(ra) # 80005ca2 <panic>
  log.lh.block[i] = b->blockno;
    800037f4:	00878713          	addi	a4,a5,8
    800037f8:	00271693          	slli	a3,a4,0x2
    800037fc:	00015717          	auipc	a4,0x15
    80003800:	27470713          	addi	a4,a4,628 # 80018a70 <log>
    80003804:	9736                	add	a4,a4,a3
    80003806:	44d4                	lw	a3,12(s1)
    80003808:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000380a:	faf608e3          	beq	a2,a5,800037ba <log_write+0x76>
  }
  release(&log.lock);
    8000380e:	00015517          	auipc	a0,0x15
    80003812:	26250513          	addi	a0,a0,610 # 80018a70 <log>
    80003816:	00003097          	auipc	ra,0x3
    8000381a:	a8a080e7          	jalr	-1398(ra) # 800062a0 <release>
}
    8000381e:	60e2                	ld	ra,24(sp)
    80003820:	6442                	ld	s0,16(sp)
    80003822:	64a2                	ld	s1,8(sp)
    80003824:	6902                	ld	s2,0(sp)
    80003826:	6105                	addi	sp,sp,32
    80003828:	8082                	ret

000000008000382a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000382a:	1101                	addi	sp,sp,-32
    8000382c:	ec06                	sd	ra,24(sp)
    8000382e:	e822                	sd	s0,16(sp)
    80003830:	e426                	sd	s1,8(sp)
    80003832:	e04a                	sd	s2,0(sp)
    80003834:	1000                	addi	s0,sp,32
    80003836:	84aa                	mv	s1,a0
    80003838:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000383a:	00005597          	auipc	a1,0x5
    8000383e:	f8658593          	addi	a1,a1,-122 # 800087c0 <syscall_list+0x230>
    80003842:	0521                	addi	a0,a0,8
    80003844:	00003097          	auipc	ra,0x3
    80003848:	918080e7          	jalr	-1768(ra) # 8000615c <initlock>
  lk->name = name;
    8000384c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003850:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003854:	0204a423          	sw	zero,40(s1)
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003872:	00850913          	addi	s2,a0,8
    80003876:	854a                	mv	a0,s2
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	974080e7          	jalr	-1676(ra) # 800061ec <acquire>
  while (lk->locked) {
    80003880:	409c                	lw	a5,0(s1)
    80003882:	cb89                	beqz	a5,80003894 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003884:	85ca                	mv	a1,s2
    80003886:	8526                	mv	a0,s1
    80003888:	ffffe097          	auipc	ra,0xffffe
    8000388c:	cd8080e7          	jalr	-808(ra) # 80001560 <sleep>
  while (lk->locked) {
    80003890:	409c                	lw	a5,0(s1)
    80003892:	fbed                	bnez	a5,80003884 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003894:	4785                	li	a5,1
    80003896:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003898:	ffffd097          	auipc	ra,0xffffd
    8000389c:	618080e7          	jalr	1560(ra) # 80000eb0 <myproc>
    800038a0:	591c                	lw	a5,48(a0)
    800038a2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038a4:	854a                	mv	a0,s2
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	9fa080e7          	jalr	-1542(ra) # 800062a0 <release>
}
    800038ae:	60e2                	ld	ra,24(sp)
    800038b0:	6442                	ld	s0,16(sp)
    800038b2:	64a2                	ld	s1,8(sp)
    800038b4:	6902                	ld	s2,0(sp)
    800038b6:	6105                	addi	sp,sp,32
    800038b8:	8082                	ret

00000000800038ba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038ba:	1101                	addi	sp,sp,-32
    800038bc:	ec06                	sd	ra,24(sp)
    800038be:	e822                	sd	s0,16(sp)
    800038c0:	e426                	sd	s1,8(sp)
    800038c2:	e04a                	sd	s2,0(sp)
    800038c4:	1000                	addi	s0,sp,32
    800038c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c8:	00850913          	addi	s2,a0,8
    800038cc:	854a                	mv	a0,s2
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	91e080e7          	jalr	-1762(ra) # 800061ec <acquire>
  lk->locked = 0;
    800038d6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038da:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038de:	8526                	mv	a0,s1
    800038e0:	ffffe097          	auipc	ra,0xffffe
    800038e4:	ce4080e7          	jalr	-796(ra) # 800015c4 <wakeup>
  release(&lk->lk);
    800038e8:	854a                	mv	a0,s2
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	9b6080e7          	jalr	-1610(ra) # 800062a0 <release>
}
    800038f2:	60e2                	ld	ra,24(sp)
    800038f4:	6442                	ld	s0,16(sp)
    800038f6:	64a2                	ld	s1,8(sp)
    800038f8:	6902                	ld	s2,0(sp)
    800038fa:	6105                	addi	sp,sp,32
    800038fc:	8082                	ret

00000000800038fe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038fe:	7179                	addi	sp,sp,-48
    80003900:	f406                	sd	ra,40(sp)
    80003902:	f022                	sd	s0,32(sp)
    80003904:	ec26                	sd	s1,24(sp)
    80003906:	e84a                	sd	s2,16(sp)
    80003908:	e44e                	sd	s3,8(sp)
    8000390a:	1800                	addi	s0,sp,48
    8000390c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000390e:	00850913          	addi	s2,a0,8
    80003912:	854a                	mv	a0,s2
    80003914:	00003097          	auipc	ra,0x3
    80003918:	8d8080e7          	jalr	-1832(ra) # 800061ec <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000391c:	409c                	lw	a5,0(s1)
    8000391e:	ef99                	bnez	a5,8000393c <holdingsleep+0x3e>
    80003920:	4481                	li	s1,0
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	97c080e7          	jalr	-1668(ra) # 800062a0 <release>
  return r;
}
    8000392c:	8526                	mv	a0,s1
    8000392e:	70a2                	ld	ra,40(sp)
    80003930:	7402                	ld	s0,32(sp)
    80003932:	64e2                	ld	s1,24(sp)
    80003934:	6942                	ld	s2,16(sp)
    80003936:	69a2                	ld	s3,8(sp)
    80003938:	6145                	addi	sp,sp,48
    8000393a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393c:	0284a983          	lw	s3,40(s1)
    80003940:	ffffd097          	auipc	ra,0xffffd
    80003944:	570080e7          	jalr	1392(ra) # 80000eb0 <myproc>
    80003948:	5904                	lw	s1,48(a0)
    8000394a:	413484b3          	sub	s1,s1,s3
    8000394e:	0014b493          	seqz	s1,s1
    80003952:	bfc1                	j	80003922 <holdingsleep+0x24>

0000000080003954 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003954:	1141                	addi	sp,sp,-16
    80003956:	e406                	sd	ra,8(sp)
    80003958:	e022                	sd	s0,0(sp)
    8000395a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000395c:	00005597          	auipc	a1,0x5
    80003960:	e7458593          	addi	a1,a1,-396 # 800087d0 <syscall_list+0x240>
    80003964:	00015517          	auipc	a0,0x15
    80003968:	25450513          	addi	a0,a0,596 # 80018bb8 <ftable>
    8000396c:	00002097          	auipc	ra,0x2
    80003970:	7f0080e7          	jalr	2032(ra) # 8000615c <initlock>
}
    80003974:	60a2                	ld	ra,8(sp)
    80003976:	6402                	ld	s0,0(sp)
    80003978:	0141                	addi	sp,sp,16
    8000397a:	8082                	ret

000000008000397c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003986:	00015517          	auipc	a0,0x15
    8000398a:	23250513          	addi	a0,a0,562 # 80018bb8 <ftable>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	85e080e7          	jalr	-1954(ra) # 800061ec <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003996:	00015497          	auipc	s1,0x15
    8000399a:	23a48493          	addi	s1,s1,570 # 80018bd0 <ftable+0x18>
    8000399e:	00016717          	auipc	a4,0x16
    800039a2:	1d270713          	addi	a4,a4,466 # 80019b70 <disk>
    if(f->ref == 0){
    800039a6:	40dc                	lw	a5,4(s1)
    800039a8:	cf99                	beqz	a5,800039c6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039aa:	02848493          	addi	s1,s1,40
    800039ae:	fee49ce3          	bne	s1,a4,800039a6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039b2:	00015517          	auipc	a0,0x15
    800039b6:	20650513          	addi	a0,a0,518 # 80018bb8 <ftable>
    800039ba:	00003097          	auipc	ra,0x3
    800039be:	8e6080e7          	jalr	-1818(ra) # 800062a0 <release>
  return 0;
    800039c2:	4481                	li	s1,0
    800039c4:	a819                	j	800039da <filealloc+0x5e>
      f->ref = 1;
    800039c6:	4785                	li	a5,1
    800039c8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ca:	00015517          	auipc	a0,0x15
    800039ce:	1ee50513          	addi	a0,a0,494 # 80018bb8 <ftable>
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	8ce080e7          	jalr	-1842(ra) # 800062a0 <release>
}
    800039da:	8526                	mv	a0,s1
    800039dc:	60e2                	ld	ra,24(sp)
    800039de:	6442                	ld	s0,16(sp)
    800039e0:	64a2                	ld	s1,8(sp)
    800039e2:	6105                	addi	sp,sp,32
    800039e4:	8082                	ret

00000000800039e6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039e6:	1101                	addi	sp,sp,-32
    800039e8:	ec06                	sd	ra,24(sp)
    800039ea:	e822                	sd	s0,16(sp)
    800039ec:	e426                	sd	s1,8(sp)
    800039ee:	1000                	addi	s0,sp,32
    800039f0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039f2:	00015517          	auipc	a0,0x15
    800039f6:	1c650513          	addi	a0,a0,454 # 80018bb8 <ftable>
    800039fa:	00002097          	auipc	ra,0x2
    800039fe:	7f2080e7          	jalr	2034(ra) # 800061ec <acquire>
  if(f->ref < 1)
    80003a02:	40dc                	lw	a5,4(s1)
    80003a04:	02f05263          	blez	a5,80003a28 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a08:	2785                	addiw	a5,a5,1
    80003a0a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a0c:	00015517          	auipc	a0,0x15
    80003a10:	1ac50513          	addi	a0,a0,428 # 80018bb8 <ftable>
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	88c080e7          	jalr	-1908(ra) # 800062a0 <release>
  return f;
}
    80003a1c:	8526                	mv	a0,s1
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6105                	addi	sp,sp,32
    80003a26:	8082                	ret
    panic("filedup");
    80003a28:	00005517          	auipc	a0,0x5
    80003a2c:	db050513          	addi	a0,a0,-592 # 800087d8 <syscall_list+0x248>
    80003a30:	00002097          	auipc	ra,0x2
    80003a34:	272080e7          	jalr	626(ra) # 80005ca2 <panic>

0000000080003a38 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a38:	7139                	addi	sp,sp,-64
    80003a3a:	fc06                	sd	ra,56(sp)
    80003a3c:	f822                	sd	s0,48(sp)
    80003a3e:	f426                	sd	s1,40(sp)
    80003a40:	f04a                	sd	s2,32(sp)
    80003a42:	ec4e                	sd	s3,24(sp)
    80003a44:	e852                	sd	s4,16(sp)
    80003a46:	e456                	sd	s5,8(sp)
    80003a48:	0080                	addi	s0,sp,64
    80003a4a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a4c:	00015517          	auipc	a0,0x15
    80003a50:	16c50513          	addi	a0,a0,364 # 80018bb8 <ftable>
    80003a54:	00002097          	auipc	ra,0x2
    80003a58:	798080e7          	jalr	1944(ra) # 800061ec <acquire>
  if(f->ref < 1)
    80003a5c:	40dc                	lw	a5,4(s1)
    80003a5e:	06f05163          	blez	a5,80003ac0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a62:	37fd                	addiw	a5,a5,-1
    80003a64:	0007871b          	sext.w	a4,a5
    80003a68:	c0dc                	sw	a5,4(s1)
    80003a6a:	06e04363          	bgtz	a4,80003ad0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a6e:	0004a903          	lw	s2,0(s1)
    80003a72:	0094ca83          	lbu	s5,9(s1)
    80003a76:	0104ba03          	ld	s4,16(s1)
    80003a7a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a7e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a82:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a86:	00015517          	auipc	a0,0x15
    80003a8a:	13250513          	addi	a0,a0,306 # 80018bb8 <ftable>
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	812080e7          	jalr	-2030(ra) # 800062a0 <release>

  if(ff.type == FD_PIPE){
    80003a96:	4785                	li	a5,1
    80003a98:	04f90d63          	beq	s2,a5,80003af2 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a9c:	3979                	addiw	s2,s2,-2
    80003a9e:	4785                	li	a5,1
    80003aa0:	0527e063          	bltu	a5,s2,80003ae0 <fileclose+0xa8>
    begin_op();
    80003aa4:	00000097          	auipc	ra,0x0
    80003aa8:	ac8080e7          	jalr	-1336(ra) # 8000356c <begin_op>
    iput(ff.ip);
    80003aac:	854e                	mv	a0,s3
    80003aae:	fffff097          	auipc	ra,0xfffff
    80003ab2:	2b6080e7          	jalr	694(ra) # 80002d64 <iput>
    end_op();
    80003ab6:	00000097          	auipc	ra,0x0
    80003aba:	b36080e7          	jalr	-1226(ra) # 800035ec <end_op>
    80003abe:	a00d                	j	80003ae0 <fileclose+0xa8>
    panic("fileclose");
    80003ac0:	00005517          	auipc	a0,0x5
    80003ac4:	d2050513          	addi	a0,a0,-736 # 800087e0 <syscall_list+0x250>
    80003ac8:	00002097          	auipc	ra,0x2
    80003acc:	1da080e7          	jalr	474(ra) # 80005ca2 <panic>
    release(&ftable.lock);
    80003ad0:	00015517          	auipc	a0,0x15
    80003ad4:	0e850513          	addi	a0,a0,232 # 80018bb8 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	7c8080e7          	jalr	1992(ra) # 800062a0 <release>
  }
}
    80003ae0:	70e2                	ld	ra,56(sp)
    80003ae2:	7442                	ld	s0,48(sp)
    80003ae4:	74a2                	ld	s1,40(sp)
    80003ae6:	7902                	ld	s2,32(sp)
    80003ae8:	69e2                	ld	s3,24(sp)
    80003aea:	6a42                	ld	s4,16(sp)
    80003aec:	6aa2                	ld	s5,8(sp)
    80003aee:	6121                	addi	sp,sp,64
    80003af0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003af2:	85d6                	mv	a1,s5
    80003af4:	8552                	mv	a0,s4
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	34c080e7          	jalr	844(ra) # 80003e42 <pipeclose>
    80003afe:	b7cd                	j	80003ae0 <fileclose+0xa8>

0000000080003b00 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b00:	715d                	addi	sp,sp,-80
    80003b02:	e486                	sd	ra,72(sp)
    80003b04:	e0a2                	sd	s0,64(sp)
    80003b06:	fc26                	sd	s1,56(sp)
    80003b08:	f84a                	sd	s2,48(sp)
    80003b0a:	f44e                	sd	s3,40(sp)
    80003b0c:	0880                	addi	s0,sp,80
    80003b0e:	84aa                	mv	s1,a0
    80003b10:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b12:	ffffd097          	auipc	ra,0xffffd
    80003b16:	39e080e7          	jalr	926(ra) # 80000eb0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b1a:	409c                	lw	a5,0(s1)
    80003b1c:	37f9                	addiw	a5,a5,-2
    80003b1e:	4705                	li	a4,1
    80003b20:	04f76763          	bltu	a4,a5,80003b6e <filestat+0x6e>
    80003b24:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b26:	6c88                	ld	a0,24(s1)
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	082080e7          	jalr	130(ra) # 80002baa <ilock>
    stati(f->ip, &st);
    80003b30:	fb840593          	addi	a1,s0,-72
    80003b34:	6c88                	ld	a0,24(s1)
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	2fe080e7          	jalr	766(ra) # 80002e34 <stati>
    iunlock(f->ip);
    80003b3e:	6c88                	ld	a0,24(s1)
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	12c080e7          	jalr	300(ra) # 80002c6c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b48:	46e1                	li	a3,24
    80003b4a:	fb840613          	addi	a2,s0,-72
    80003b4e:	85ce                	mv	a1,s3
    80003b50:	05093503          	ld	a0,80(s2)
    80003b54:	ffffd097          	auipc	ra,0xffffd
    80003b58:	fe6080e7          	jalr	-26(ra) # 80000b3a <copyout>
    80003b5c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b60:	60a6                	ld	ra,72(sp)
    80003b62:	6406                	ld	s0,64(sp)
    80003b64:	74e2                	ld	s1,56(sp)
    80003b66:	7942                	ld	s2,48(sp)
    80003b68:	79a2                	ld	s3,40(sp)
    80003b6a:	6161                	addi	sp,sp,80
    80003b6c:	8082                	ret
  return -1;
    80003b6e:	557d                	li	a0,-1
    80003b70:	bfc5                	j	80003b60 <filestat+0x60>

0000000080003b72 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b72:	7179                	addi	sp,sp,-48
    80003b74:	f406                	sd	ra,40(sp)
    80003b76:	f022                	sd	s0,32(sp)
    80003b78:	ec26                	sd	s1,24(sp)
    80003b7a:	e84a                	sd	s2,16(sp)
    80003b7c:	e44e                	sd	s3,8(sp)
    80003b7e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b80:	00854783          	lbu	a5,8(a0)
    80003b84:	c3d5                	beqz	a5,80003c28 <fileread+0xb6>
    80003b86:	84aa                	mv	s1,a0
    80003b88:	89ae                	mv	s3,a1
    80003b8a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8c:	411c                	lw	a5,0(a0)
    80003b8e:	4705                	li	a4,1
    80003b90:	04e78963          	beq	a5,a4,80003be2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b94:	470d                	li	a4,3
    80003b96:	04e78d63          	beq	a5,a4,80003bf0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b9a:	4709                	li	a4,2
    80003b9c:	06e79e63          	bne	a5,a4,80003c18 <fileread+0xa6>
    ilock(f->ip);
    80003ba0:	6d08                	ld	a0,24(a0)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	008080e7          	jalr	8(ra) # 80002baa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003baa:	874a                	mv	a4,s2
    80003bac:	5094                	lw	a3,32(s1)
    80003bae:	864e                	mv	a2,s3
    80003bb0:	4585                	li	a1,1
    80003bb2:	6c88                	ld	a0,24(s1)
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	2aa080e7          	jalr	682(ra) # 80002e5e <readi>
    80003bbc:	892a                	mv	s2,a0
    80003bbe:	00a05563          	blez	a0,80003bc8 <fileread+0x56>
      f->off += r;
    80003bc2:	509c                	lw	a5,32(s1)
    80003bc4:	9fa9                	addw	a5,a5,a0
    80003bc6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bc8:	6c88                	ld	a0,24(s1)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	0a2080e7          	jalr	162(ra) # 80002c6c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	70a2                	ld	ra,40(sp)
    80003bd6:	7402                	ld	s0,32(sp)
    80003bd8:	64e2                	ld	s1,24(sp)
    80003bda:	6942                	ld	s2,16(sp)
    80003bdc:	69a2                	ld	s3,8(sp)
    80003bde:	6145                	addi	sp,sp,48
    80003be0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003be2:	6908                	ld	a0,16(a0)
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	3ce080e7          	jalr	974(ra) # 80003fb2 <piperead>
    80003bec:	892a                	mv	s2,a0
    80003bee:	b7d5                	j	80003bd2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bf0:	02451783          	lh	a5,36(a0)
    80003bf4:	03079693          	slli	a3,a5,0x30
    80003bf8:	92c1                	srli	a3,a3,0x30
    80003bfa:	4725                	li	a4,9
    80003bfc:	02d76863          	bltu	a4,a3,80003c2c <fileread+0xba>
    80003c00:	0792                	slli	a5,a5,0x4
    80003c02:	00015717          	auipc	a4,0x15
    80003c06:	f1670713          	addi	a4,a4,-234 # 80018b18 <devsw>
    80003c0a:	97ba                	add	a5,a5,a4
    80003c0c:	639c                	ld	a5,0(a5)
    80003c0e:	c38d                	beqz	a5,80003c30 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c10:	4505                	li	a0,1
    80003c12:	9782                	jalr	a5
    80003c14:	892a                	mv	s2,a0
    80003c16:	bf75                	j	80003bd2 <fileread+0x60>
    panic("fileread");
    80003c18:	00005517          	auipc	a0,0x5
    80003c1c:	bd850513          	addi	a0,a0,-1064 # 800087f0 <syscall_list+0x260>
    80003c20:	00002097          	auipc	ra,0x2
    80003c24:	082080e7          	jalr	130(ra) # 80005ca2 <panic>
    return -1;
    80003c28:	597d                	li	s2,-1
    80003c2a:	b765                	j	80003bd2 <fileread+0x60>
      return -1;
    80003c2c:	597d                	li	s2,-1
    80003c2e:	b755                	j	80003bd2 <fileread+0x60>
    80003c30:	597d                	li	s2,-1
    80003c32:	b745                	j	80003bd2 <fileread+0x60>

0000000080003c34 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c34:	715d                	addi	sp,sp,-80
    80003c36:	e486                	sd	ra,72(sp)
    80003c38:	e0a2                	sd	s0,64(sp)
    80003c3a:	fc26                	sd	s1,56(sp)
    80003c3c:	f84a                	sd	s2,48(sp)
    80003c3e:	f44e                	sd	s3,40(sp)
    80003c40:	f052                	sd	s4,32(sp)
    80003c42:	ec56                	sd	s5,24(sp)
    80003c44:	e85a                	sd	s6,16(sp)
    80003c46:	e45e                	sd	s7,8(sp)
    80003c48:	e062                	sd	s8,0(sp)
    80003c4a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c4c:	00954783          	lbu	a5,9(a0)
    80003c50:	10078663          	beqz	a5,80003d5c <filewrite+0x128>
    80003c54:	892a                	mv	s2,a0
    80003c56:	8aae                	mv	s5,a1
    80003c58:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c5a:	411c                	lw	a5,0(a0)
    80003c5c:	4705                	li	a4,1
    80003c5e:	02e78263          	beq	a5,a4,80003c82 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c62:	470d                	li	a4,3
    80003c64:	02e78663          	beq	a5,a4,80003c90 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c68:	4709                	li	a4,2
    80003c6a:	0ee79163          	bne	a5,a4,80003d4c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c6e:	0ac05d63          	blez	a2,80003d28 <filewrite+0xf4>
    int i = 0;
    80003c72:	4981                	li	s3,0
    80003c74:	6b05                	lui	s6,0x1
    80003c76:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c7a:	6b85                	lui	s7,0x1
    80003c7c:	c00b8b9b          	addiw	s7,s7,-1024
    80003c80:	a861                	j	80003d18 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c82:	6908                	ld	a0,16(a0)
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	22e080e7          	jalr	558(ra) # 80003eb2 <pipewrite>
    80003c8c:	8a2a                	mv	s4,a0
    80003c8e:	a045                	j	80003d2e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c90:	02451783          	lh	a5,36(a0)
    80003c94:	03079693          	slli	a3,a5,0x30
    80003c98:	92c1                	srli	a3,a3,0x30
    80003c9a:	4725                	li	a4,9
    80003c9c:	0cd76263          	bltu	a4,a3,80003d60 <filewrite+0x12c>
    80003ca0:	0792                	slli	a5,a5,0x4
    80003ca2:	00015717          	auipc	a4,0x15
    80003ca6:	e7670713          	addi	a4,a4,-394 # 80018b18 <devsw>
    80003caa:	97ba                	add	a5,a5,a4
    80003cac:	679c                	ld	a5,8(a5)
    80003cae:	cbdd                	beqz	a5,80003d64 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cb0:	4505                	li	a0,1
    80003cb2:	9782                	jalr	a5
    80003cb4:	8a2a                	mv	s4,a0
    80003cb6:	a8a5                	j	80003d2e <filewrite+0xfa>
    80003cb8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	8b0080e7          	jalr	-1872(ra) # 8000356c <begin_op>
      ilock(f->ip);
    80003cc4:	01893503          	ld	a0,24(s2)
    80003cc8:	fffff097          	auipc	ra,0xfffff
    80003ccc:	ee2080e7          	jalr	-286(ra) # 80002baa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cd0:	8762                	mv	a4,s8
    80003cd2:	02092683          	lw	a3,32(s2)
    80003cd6:	01598633          	add	a2,s3,s5
    80003cda:	4585                	li	a1,1
    80003cdc:	01893503          	ld	a0,24(s2)
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	276080e7          	jalr	630(ra) # 80002f56 <writei>
    80003ce8:	84aa                	mv	s1,a0
    80003cea:	00a05763          	blez	a0,80003cf8 <filewrite+0xc4>
        f->off += r;
    80003cee:	02092783          	lw	a5,32(s2)
    80003cf2:	9fa9                	addw	a5,a5,a0
    80003cf4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cf8:	01893503          	ld	a0,24(s2)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	f70080e7          	jalr	-144(ra) # 80002c6c <iunlock>
      end_op();
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	8e8080e7          	jalr	-1816(ra) # 800035ec <end_op>

      if(r != n1){
    80003d0c:	009c1f63          	bne	s8,s1,80003d2a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d10:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d14:	0149db63          	bge	s3,s4,80003d2a <filewrite+0xf6>
      int n1 = n - i;
    80003d18:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d1c:	84be                	mv	s1,a5
    80003d1e:	2781                	sext.w	a5,a5
    80003d20:	f8fb5ce3          	bge	s6,a5,80003cb8 <filewrite+0x84>
    80003d24:	84de                	mv	s1,s7
    80003d26:	bf49                	j	80003cb8 <filewrite+0x84>
    int i = 0;
    80003d28:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d2a:	013a1f63          	bne	s4,s3,80003d48 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d2e:	8552                	mv	a0,s4
    80003d30:	60a6                	ld	ra,72(sp)
    80003d32:	6406                	ld	s0,64(sp)
    80003d34:	74e2                	ld	s1,56(sp)
    80003d36:	7942                	ld	s2,48(sp)
    80003d38:	79a2                	ld	s3,40(sp)
    80003d3a:	7a02                	ld	s4,32(sp)
    80003d3c:	6ae2                	ld	s5,24(sp)
    80003d3e:	6b42                	ld	s6,16(sp)
    80003d40:	6ba2                	ld	s7,8(sp)
    80003d42:	6c02                	ld	s8,0(sp)
    80003d44:	6161                	addi	sp,sp,80
    80003d46:	8082                	ret
    ret = (i == n ? n : -1);
    80003d48:	5a7d                	li	s4,-1
    80003d4a:	b7d5                	j	80003d2e <filewrite+0xfa>
    panic("filewrite");
    80003d4c:	00005517          	auipc	a0,0x5
    80003d50:	ab450513          	addi	a0,a0,-1356 # 80008800 <syscall_list+0x270>
    80003d54:	00002097          	auipc	ra,0x2
    80003d58:	f4e080e7          	jalr	-178(ra) # 80005ca2 <panic>
    return -1;
    80003d5c:	5a7d                	li	s4,-1
    80003d5e:	bfc1                	j	80003d2e <filewrite+0xfa>
      return -1;
    80003d60:	5a7d                	li	s4,-1
    80003d62:	b7f1                	j	80003d2e <filewrite+0xfa>
    80003d64:	5a7d                	li	s4,-1
    80003d66:	b7e1                	j	80003d2e <filewrite+0xfa>

0000000080003d68 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d68:	7179                	addi	sp,sp,-48
    80003d6a:	f406                	sd	ra,40(sp)
    80003d6c:	f022                	sd	s0,32(sp)
    80003d6e:	ec26                	sd	s1,24(sp)
    80003d70:	e84a                	sd	s2,16(sp)
    80003d72:	e44e                	sd	s3,8(sp)
    80003d74:	e052                	sd	s4,0(sp)
    80003d76:	1800                	addi	s0,sp,48
    80003d78:	84aa                	mv	s1,a0
    80003d7a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d7c:	0005b023          	sd	zero,0(a1)
    80003d80:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	bf8080e7          	jalr	-1032(ra) # 8000397c <filealloc>
    80003d8c:	e088                	sd	a0,0(s1)
    80003d8e:	c551                	beqz	a0,80003e1a <pipealloc+0xb2>
    80003d90:	00000097          	auipc	ra,0x0
    80003d94:	bec080e7          	jalr	-1044(ra) # 8000397c <filealloc>
    80003d98:	00aa3023          	sd	a0,0(s4)
    80003d9c:	c92d                	beqz	a0,80003e0e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d9e:	ffffc097          	auipc	ra,0xffffc
    80003da2:	37a080e7          	jalr	890(ra) # 80000118 <kalloc>
    80003da6:	892a                	mv	s2,a0
    80003da8:	c125                	beqz	a0,80003e08 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003daa:	4985                	li	s3,1
    80003dac:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003db0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003db4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003db8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dbc:	00004597          	auipc	a1,0x4
    80003dc0:	67458593          	addi	a1,a1,1652 # 80008430 <states.1723+0x1a8>
    80003dc4:	00002097          	auipc	ra,0x2
    80003dc8:	398080e7          	jalr	920(ra) # 8000615c <initlock>
  (*f0)->type = FD_PIPE;
    80003dcc:	609c                	ld	a5,0(s1)
    80003dce:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dd2:	609c                	ld	a5,0(s1)
    80003dd4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dd8:	609c                	ld	a5,0(s1)
    80003dda:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dde:	609c                	ld	a5,0(s1)
    80003de0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003de4:	000a3783          	ld	a5,0(s4)
    80003de8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dec:	000a3783          	ld	a5,0(s4)
    80003df0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003df4:	000a3783          	ld	a5,0(s4)
    80003df8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dfc:	000a3783          	ld	a5,0(s4)
    80003e00:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e04:	4501                	li	a0,0
    80003e06:	a025                	j	80003e2e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e08:	6088                	ld	a0,0(s1)
    80003e0a:	e501                	bnez	a0,80003e12 <pipealloc+0xaa>
    80003e0c:	a039                	j	80003e1a <pipealloc+0xb2>
    80003e0e:	6088                	ld	a0,0(s1)
    80003e10:	c51d                	beqz	a0,80003e3e <pipealloc+0xd6>
    fileclose(*f0);
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	c26080e7          	jalr	-986(ra) # 80003a38 <fileclose>
  if(*f1)
    80003e1a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e1e:	557d                	li	a0,-1
  if(*f1)
    80003e20:	c799                	beqz	a5,80003e2e <pipealloc+0xc6>
    fileclose(*f1);
    80003e22:	853e                	mv	a0,a5
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	c14080e7          	jalr	-1004(ra) # 80003a38 <fileclose>
  return -1;
    80003e2c:	557d                	li	a0,-1
}
    80003e2e:	70a2                	ld	ra,40(sp)
    80003e30:	7402                	ld	s0,32(sp)
    80003e32:	64e2                	ld	s1,24(sp)
    80003e34:	6942                	ld	s2,16(sp)
    80003e36:	69a2                	ld	s3,8(sp)
    80003e38:	6a02                	ld	s4,0(sp)
    80003e3a:	6145                	addi	sp,sp,48
    80003e3c:	8082                	ret
  return -1;
    80003e3e:	557d                	li	a0,-1
    80003e40:	b7fd                	j	80003e2e <pipealloc+0xc6>

0000000080003e42 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e42:	1101                	addi	sp,sp,-32
    80003e44:	ec06                	sd	ra,24(sp)
    80003e46:	e822                	sd	s0,16(sp)
    80003e48:	e426                	sd	s1,8(sp)
    80003e4a:	e04a                	sd	s2,0(sp)
    80003e4c:	1000                	addi	s0,sp,32
    80003e4e:	84aa                	mv	s1,a0
    80003e50:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e52:	00002097          	auipc	ra,0x2
    80003e56:	39a080e7          	jalr	922(ra) # 800061ec <acquire>
  if(writable){
    80003e5a:	02090d63          	beqz	s2,80003e94 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e5e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e62:	21848513          	addi	a0,s1,536
    80003e66:	ffffd097          	auipc	ra,0xffffd
    80003e6a:	75e080e7          	jalr	1886(ra) # 800015c4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e6e:	2204b783          	ld	a5,544(s1)
    80003e72:	eb95                	bnez	a5,80003ea6 <pipeclose+0x64>
    release(&pi->lock);
    80003e74:	8526                	mv	a0,s1
    80003e76:	00002097          	auipc	ra,0x2
    80003e7a:	42a080e7          	jalr	1066(ra) # 800062a0 <release>
    kfree((char*)pi);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	ffffc097          	auipc	ra,0xffffc
    80003e84:	19c080e7          	jalr	412(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e88:	60e2                	ld	ra,24(sp)
    80003e8a:	6442                	ld	s0,16(sp)
    80003e8c:	64a2                	ld	s1,8(sp)
    80003e8e:	6902                	ld	s2,0(sp)
    80003e90:	6105                	addi	sp,sp,32
    80003e92:	8082                	ret
    pi->readopen = 0;
    80003e94:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e98:	21c48513          	addi	a0,s1,540
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	728080e7          	jalr	1832(ra) # 800015c4 <wakeup>
    80003ea4:	b7e9                	j	80003e6e <pipeclose+0x2c>
    release(&pi->lock);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	00002097          	auipc	ra,0x2
    80003eac:	3f8080e7          	jalr	1016(ra) # 800062a0 <release>
}
    80003eb0:	bfe1                	j	80003e88 <pipeclose+0x46>

0000000080003eb2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eb2:	7159                	addi	sp,sp,-112
    80003eb4:	f486                	sd	ra,104(sp)
    80003eb6:	f0a2                	sd	s0,96(sp)
    80003eb8:	eca6                	sd	s1,88(sp)
    80003eba:	e8ca                	sd	s2,80(sp)
    80003ebc:	e4ce                	sd	s3,72(sp)
    80003ebe:	e0d2                	sd	s4,64(sp)
    80003ec0:	fc56                	sd	s5,56(sp)
    80003ec2:	f85a                	sd	s6,48(sp)
    80003ec4:	f45e                	sd	s7,40(sp)
    80003ec6:	f062                	sd	s8,32(sp)
    80003ec8:	ec66                	sd	s9,24(sp)
    80003eca:	1880                	addi	s0,sp,112
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	8aae                	mv	s5,a1
    80003ed0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	fde080e7          	jalr	-34(ra) # 80000eb0 <myproc>
    80003eda:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00002097          	auipc	ra,0x2
    80003ee2:	30e080e7          	jalr	782(ra) # 800061ec <acquire>
  while(i < n){
    80003ee6:	0d405463          	blez	s4,80003fae <pipewrite+0xfc>
    80003eea:	8ba6                	mv	s7,s1
  int i = 0;
    80003eec:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eee:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ef0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ef4:	21c48c13          	addi	s8,s1,540
    80003ef8:	a08d                	j	80003f5a <pipewrite+0xa8>
      release(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	3a4080e7          	jalr	932(ra) # 800062a0 <release>
      return -1;
    80003f04:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f06:	854a                	mv	a0,s2
    80003f08:	70a6                	ld	ra,104(sp)
    80003f0a:	7406                	ld	s0,96(sp)
    80003f0c:	64e6                	ld	s1,88(sp)
    80003f0e:	6946                	ld	s2,80(sp)
    80003f10:	69a6                	ld	s3,72(sp)
    80003f12:	6a06                	ld	s4,64(sp)
    80003f14:	7ae2                	ld	s5,56(sp)
    80003f16:	7b42                	ld	s6,48(sp)
    80003f18:	7ba2                	ld	s7,40(sp)
    80003f1a:	7c02                	ld	s8,32(sp)
    80003f1c:	6ce2                	ld	s9,24(sp)
    80003f1e:	6165                	addi	sp,sp,112
    80003f20:	8082                	ret
      wakeup(&pi->nread);
    80003f22:	8566                	mv	a0,s9
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	6a0080e7          	jalr	1696(ra) # 800015c4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f2c:	85de                	mv	a1,s7
    80003f2e:	8562                	mv	a0,s8
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	630080e7          	jalr	1584(ra) # 80001560 <sleep>
    80003f38:	a839                	j	80003f56 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f3a:	21c4a783          	lw	a5,540(s1)
    80003f3e:	0017871b          	addiw	a4,a5,1
    80003f42:	20e4ae23          	sw	a4,540(s1)
    80003f46:	1ff7f793          	andi	a5,a5,511
    80003f4a:	97a6                	add	a5,a5,s1
    80003f4c:	f9f44703          	lbu	a4,-97(s0)
    80003f50:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f54:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f56:	05495063          	bge	s2,s4,80003f96 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003f5a:	2204a783          	lw	a5,544(s1)
    80003f5e:	dfd1                	beqz	a5,80003efa <pipewrite+0x48>
    80003f60:	854e                	mv	a0,s3
    80003f62:	ffffe097          	auipc	ra,0xffffe
    80003f66:	8a6080e7          	jalr	-1882(ra) # 80001808 <killed>
    80003f6a:	f941                	bnez	a0,80003efa <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6c:	2184a783          	lw	a5,536(s1)
    80003f70:	21c4a703          	lw	a4,540(s1)
    80003f74:	2007879b          	addiw	a5,a5,512
    80003f78:	faf705e3          	beq	a4,a5,80003f22 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7c:	4685                	li	a3,1
    80003f7e:	01590633          	add	a2,s2,s5
    80003f82:	f9f40593          	addi	a1,s0,-97
    80003f86:	0509b503          	ld	a0,80(s3)
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	c70080e7          	jalr	-912(ra) # 80000bfa <copyin>
    80003f92:	fb6514e3          	bne	a0,s6,80003f3a <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f96:	21848513          	addi	a0,s1,536
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	62a080e7          	jalr	1578(ra) # 800015c4 <wakeup>
  release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	2fc080e7          	jalr	764(ra) # 800062a0 <release>
  return i;
    80003fac:	bfa9                	j	80003f06 <pipewrite+0x54>
  int i = 0;
    80003fae:	4901                	li	s2,0
    80003fb0:	b7dd                	j	80003f96 <pipewrite+0xe4>

0000000080003fb2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fb2:	715d                	addi	sp,sp,-80
    80003fb4:	e486                	sd	ra,72(sp)
    80003fb6:	e0a2                	sd	s0,64(sp)
    80003fb8:	fc26                	sd	s1,56(sp)
    80003fba:	f84a                	sd	s2,48(sp)
    80003fbc:	f44e                	sd	s3,40(sp)
    80003fbe:	f052                	sd	s4,32(sp)
    80003fc0:	ec56                	sd	s5,24(sp)
    80003fc2:	e85a                	sd	s6,16(sp)
    80003fc4:	0880                	addi	s0,sp,80
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	892e                	mv	s2,a1
    80003fca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	ee4080e7          	jalr	-284(ra) # 80000eb0 <myproc>
    80003fd4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fd6:	8b26                	mv	s6,s1
    80003fd8:	8526                	mv	a0,s1
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	212080e7          	jalr	530(ra) # 800061ec <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe2:	2184a703          	lw	a4,536(s1)
    80003fe6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fee:	02f71763          	bne	a4,a5,8000401c <piperead+0x6a>
    80003ff2:	2244a783          	lw	a5,548(s1)
    80003ff6:	c39d                	beqz	a5,8000401c <piperead+0x6a>
    if(killed(pr)){
    80003ff8:	8552                	mv	a0,s4
    80003ffa:	ffffe097          	auipc	ra,0xffffe
    80003ffe:	80e080e7          	jalr	-2034(ra) # 80001808 <killed>
    80004002:	e941                	bnez	a0,80004092 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004004:	85da                	mv	a1,s6
    80004006:	854e                	mv	a0,s3
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	558080e7          	jalr	1368(ra) # 80001560 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004010:	2184a703          	lw	a4,536(s1)
    80004014:	21c4a783          	lw	a5,540(s1)
    80004018:	fcf70de3          	beq	a4,a5,80003ff2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401c:	09505263          	blez	s5,800040a0 <piperead+0xee>
    80004020:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004022:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004024:	2184a783          	lw	a5,536(s1)
    80004028:	21c4a703          	lw	a4,540(s1)
    8000402c:	02f70d63          	beq	a4,a5,80004066 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004030:	0017871b          	addiw	a4,a5,1
    80004034:	20e4ac23          	sw	a4,536(s1)
    80004038:	1ff7f793          	andi	a5,a5,511
    8000403c:	97a6                	add	a5,a5,s1
    8000403e:	0187c783          	lbu	a5,24(a5)
    80004042:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004046:	4685                	li	a3,1
    80004048:	fbf40613          	addi	a2,s0,-65
    8000404c:	85ca                	mv	a1,s2
    8000404e:	050a3503          	ld	a0,80(s4)
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	ae8080e7          	jalr	-1304(ra) # 80000b3a <copyout>
    8000405a:	01650663          	beq	a0,s6,80004066 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000405e:	2985                	addiw	s3,s3,1
    80004060:	0905                	addi	s2,s2,1
    80004062:	fd3a91e3          	bne	s5,s3,80004024 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004066:	21c48513          	addi	a0,s1,540
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	55a080e7          	jalr	1370(ra) # 800015c4 <wakeup>
  release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	22c080e7          	jalr	556(ra) # 800062a0 <release>
  return i;
}
    8000407c:	854e                	mv	a0,s3
    8000407e:	60a6                	ld	ra,72(sp)
    80004080:	6406                	ld	s0,64(sp)
    80004082:	74e2                	ld	s1,56(sp)
    80004084:	7942                	ld	s2,48(sp)
    80004086:	79a2                	ld	s3,40(sp)
    80004088:	7a02                	ld	s4,32(sp)
    8000408a:	6ae2                	ld	s5,24(sp)
    8000408c:	6b42                	ld	s6,16(sp)
    8000408e:	6161                	addi	sp,sp,80
    80004090:	8082                	ret
      release(&pi->lock);
    80004092:	8526                	mv	a0,s1
    80004094:	00002097          	auipc	ra,0x2
    80004098:	20c080e7          	jalr	524(ra) # 800062a0 <release>
      return -1;
    8000409c:	59fd                	li	s3,-1
    8000409e:	bff9                	j	8000407c <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a0:	4981                	li	s3,0
    800040a2:	b7d1                	j	80004066 <piperead+0xb4>

00000000800040a4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040a4:	1141                	addi	sp,sp,-16
    800040a6:	e422                	sd	s0,8(sp)
    800040a8:	0800                	addi	s0,sp,16
    800040aa:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040ac:	8905                	andi	a0,a0,1
    800040ae:	c111                	beqz	a0,800040b2 <flags2perm+0xe>
      perm = PTE_X;
    800040b0:	4521                	li	a0,8
    if(flags & 0x2)
    800040b2:	8b89                	andi	a5,a5,2
    800040b4:	c399                	beqz	a5,800040ba <flags2perm+0x16>
      perm |= PTE_W;
    800040b6:	00456513          	ori	a0,a0,4
    return perm;
}
    800040ba:	6422                	ld	s0,8(sp)
    800040bc:	0141                	addi	sp,sp,16
    800040be:	8082                	ret

00000000800040c0 <exec>:

int
exec(char *path, char **argv)
{
    800040c0:	df010113          	addi	sp,sp,-528
    800040c4:	20113423          	sd	ra,520(sp)
    800040c8:	20813023          	sd	s0,512(sp)
    800040cc:	ffa6                	sd	s1,504(sp)
    800040ce:	fbca                	sd	s2,496(sp)
    800040d0:	f7ce                	sd	s3,488(sp)
    800040d2:	f3d2                	sd	s4,480(sp)
    800040d4:	efd6                	sd	s5,472(sp)
    800040d6:	ebda                	sd	s6,464(sp)
    800040d8:	e7de                	sd	s7,456(sp)
    800040da:	e3e2                	sd	s8,448(sp)
    800040dc:	ff66                	sd	s9,440(sp)
    800040de:	fb6a                	sd	s10,432(sp)
    800040e0:	f76e                	sd	s11,424(sp)
    800040e2:	0c00                	addi	s0,sp,528
    800040e4:	84aa                	mv	s1,a0
    800040e6:	dea43c23          	sd	a0,-520(s0)
    800040ea:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	dc2080e7          	jalr	-574(ra) # 80000eb0 <myproc>
    800040f6:	892a                	mv	s2,a0

  begin_op();
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	474080e7          	jalr	1140(ra) # 8000356c <begin_op>

  if((ip = namei(path)) == 0){
    80004100:	8526                	mv	a0,s1
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	24e080e7          	jalr	590(ra) # 80003350 <namei>
    8000410a:	c92d                	beqz	a0,8000417c <exec+0xbc>
    8000410c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	a9c080e7          	jalr	-1380(ra) # 80002baa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004116:	04000713          	li	a4,64
    8000411a:	4681                	li	a3,0
    8000411c:	e5040613          	addi	a2,s0,-432
    80004120:	4581                	li	a1,0
    80004122:	8526                	mv	a0,s1
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	d3a080e7          	jalr	-710(ra) # 80002e5e <readi>
    8000412c:	04000793          	li	a5,64
    80004130:	00f51a63          	bne	a0,a5,80004144 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004134:	e5042703          	lw	a4,-432(s0)
    80004138:	464c47b7          	lui	a5,0x464c4
    8000413c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004140:	04f70463          	beq	a4,a5,80004188 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004144:	8526                	mv	a0,s1
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	cc6080e7          	jalr	-826(ra) # 80002e0c <iunlockput>
    end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	49e080e7          	jalr	1182(ra) # 800035ec <end_op>
  }
  return -1;
    80004156:	557d                	li	a0,-1
}
    80004158:	20813083          	ld	ra,520(sp)
    8000415c:	20013403          	ld	s0,512(sp)
    80004160:	74fe                	ld	s1,504(sp)
    80004162:	795e                	ld	s2,496(sp)
    80004164:	79be                	ld	s3,488(sp)
    80004166:	7a1e                	ld	s4,480(sp)
    80004168:	6afe                	ld	s5,472(sp)
    8000416a:	6b5e                	ld	s6,464(sp)
    8000416c:	6bbe                	ld	s7,456(sp)
    8000416e:	6c1e                	ld	s8,448(sp)
    80004170:	7cfa                	ld	s9,440(sp)
    80004172:	7d5a                	ld	s10,432(sp)
    80004174:	7dba                	ld	s11,424(sp)
    80004176:	21010113          	addi	sp,sp,528
    8000417a:	8082                	ret
    end_op();
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	470080e7          	jalr	1136(ra) # 800035ec <end_op>
    return -1;
    80004184:	557d                	li	a0,-1
    80004186:	bfc9                	j	80004158 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004188:	854a                	mv	a0,s2
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	dee080e7          	jalr	-530(ra) # 80000f78 <proc_pagetable>
    80004192:	8baa                	mv	s7,a0
    80004194:	d945                	beqz	a0,80004144 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004196:	e7042983          	lw	s3,-400(s0)
    8000419a:	e8845783          	lhu	a5,-376(s0)
    8000419e:	c7ad                	beqz	a5,80004208 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a0:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a2:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041a4:	6c85                	lui	s9,0x1
    800041a6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041aa:	def43823          	sd	a5,-528(s0)
    800041ae:	ac0d                	j	800043e0 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041b0:	00004517          	auipc	a0,0x4
    800041b4:	66050513          	addi	a0,a0,1632 # 80008810 <syscall_list+0x280>
    800041b8:	00002097          	auipc	ra,0x2
    800041bc:	aea080e7          	jalr	-1302(ra) # 80005ca2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c0:	8756                	mv	a4,s5
    800041c2:	012d86bb          	addw	a3,s11,s2
    800041c6:	4581                	li	a1,0
    800041c8:	8526                	mv	a0,s1
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	c94080e7          	jalr	-876(ra) # 80002e5e <readi>
    800041d2:	2501                	sext.w	a0,a0
    800041d4:	1aaa9a63          	bne	s5,a0,80004388 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800041d8:	6785                	lui	a5,0x1
    800041da:	0127893b          	addw	s2,a5,s2
    800041de:	77fd                	lui	a5,0xfffff
    800041e0:	01478a3b          	addw	s4,a5,s4
    800041e4:	1f897563          	bgeu	s2,s8,800043ce <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800041e8:	02091593          	slli	a1,s2,0x20
    800041ec:	9181                	srli	a1,a1,0x20
    800041ee:	95ea                	add	a1,a1,s10
    800041f0:	855e                	mv	a0,s7
    800041f2:	ffffc097          	auipc	ra,0xffffc
    800041f6:	318080e7          	jalr	792(ra) # 8000050a <walkaddr>
    800041fa:	862a                	mv	a2,a0
    if(pa == 0)
    800041fc:	d955                	beqz	a0,800041b0 <exec+0xf0>
      n = PGSIZE;
    800041fe:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004200:	fd9a70e3          	bgeu	s4,s9,800041c0 <exec+0x100>
      n = sz - i;
    80004204:	8ad2                	mv	s5,s4
    80004206:	bf6d                	j	800041c0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004208:	4a01                	li	s4,0
  iunlockput(ip);
    8000420a:	8526                	mv	a0,s1
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	c00080e7          	jalr	-1024(ra) # 80002e0c <iunlockput>
  end_op();
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	3d8080e7          	jalr	984(ra) # 800035ec <end_op>
  p = myproc();
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	c94080e7          	jalr	-876(ra) # 80000eb0 <myproc>
    80004224:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004226:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000422a:	6785                	lui	a5,0x1
    8000422c:	17fd                	addi	a5,a5,-1
    8000422e:	9a3e                	add	s4,s4,a5
    80004230:	757d                	lui	a0,0xfffff
    80004232:	00aa77b3          	and	a5,s4,a0
    80004236:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000423a:	4691                	li	a3,4
    8000423c:	6609                	lui	a2,0x2
    8000423e:	963e                	add	a2,a2,a5
    80004240:	85be                	mv	a1,a5
    80004242:	855e                	mv	a0,s7
    80004244:	ffffc097          	auipc	ra,0xffffc
    80004248:	69e080e7          	jalr	1694(ra) # 800008e2 <uvmalloc>
    8000424c:	8b2a                	mv	s6,a0
  ip = 0;
    8000424e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004250:	12050c63          	beqz	a0,80004388 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004254:	75f9                	lui	a1,0xffffe
    80004256:	95aa                	add	a1,a1,a0
    80004258:	855e                	mv	a0,s7
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	8ae080e7          	jalr	-1874(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    80004262:	7c7d                	lui	s8,0xfffff
    80004264:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004266:	e0043783          	ld	a5,-512(s0)
    8000426a:	6388                	ld	a0,0(a5)
    8000426c:	c535                	beqz	a0,800042d8 <exec+0x218>
    8000426e:	e9040993          	addi	s3,s0,-368
    80004272:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004276:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	084080e7          	jalr	132(ra) # 800002fc <strlen>
    80004280:	2505                	addiw	a0,a0,1
    80004282:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004286:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000428a:	13896663          	bltu	s2,s8,800043b6 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000428e:	e0043d83          	ld	s11,-512(s0)
    80004292:	000dba03          	ld	s4,0(s11)
    80004296:	8552                	mv	a0,s4
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	064080e7          	jalr	100(ra) # 800002fc <strlen>
    800042a0:	0015069b          	addiw	a3,a0,1
    800042a4:	8652                	mv	a2,s4
    800042a6:	85ca                	mv	a1,s2
    800042a8:	855e                	mv	a0,s7
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	890080e7          	jalr	-1904(ra) # 80000b3a <copyout>
    800042b2:	10054663          	bltz	a0,800043be <exec+0x2fe>
    ustack[argc] = sp;
    800042b6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ba:	0485                	addi	s1,s1,1
    800042bc:	008d8793          	addi	a5,s11,8
    800042c0:	e0f43023          	sd	a5,-512(s0)
    800042c4:	008db503          	ld	a0,8(s11)
    800042c8:	c911                	beqz	a0,800042dc <exec+0x21c>
    if(argc >= MAXARG)
    800042ca:	09a1                	addi	s3,s3,8
    800042cc:	fb3c96e3          	bne	s9,s3,80004278 <exec+0x1b8>
  sz = sz1;
    800042d0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042d4:	4481                	li	s1,0
    800042d6:	a84d                	j	80004388 <exec+0x2c8>
  sp = sz;
    800042d8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042da:	4481                	li	s1,0
  ustack[argc] = 0;
    800042dc:	00349793          	slli	a5,s1,0x3
    800042e0:	f9040713          	addi	a4,s0,-112
    800042e4:	97ba                	add	a5,a5,a4
    800042e6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042ea:	00148693          	addi	a3,s1,1
    800042ee:	068e                	slli	a3,a3,0x3
    800042f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042f4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042f8:	01897663          	bgeu	s2,s8,80004304 <exec+0x244>
  sz = sz1;
    800042fc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004300:	4481                	li	s1,0
    80004302:	a059                	j	80004388 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004304:	e9040613          	addi	a2,s0,-368
    80004308:	85ca                	mv	a1,s2
    8000430a:	855e                	mv	a0,s7
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	82e080e7          	jalr	-2002(ra) # 80000b3a <copyout>
    80004314:	0a054963          	bltz	a0,800043c6 <exec+0x306>
  p->trapframe->a1 = sp;
    80004318:	058ab783          	ld	a5,88(s5)
    8000431c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004320:	df843783          	ld	a5,-520(s0)
    80004324:	0007c703          	lbu	a4,0(a5)
    80004328:	cf11                	beqz	a4,80004344 <exec+0x284>
    8000432a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000432c:	02f00693          	li	a3,47
    80004330:	a039                	j	8000433e <exec+0x27e>
      last = s+1;
    80004332:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004336:	0785                	addi	a5,a5,1
    80004338:	fff7c703          	lbu	a4,-1(a5)
    8000433c:	c701                	beqz	a4,80004344 <exec+0x284>
    if(*s == '/')
    8000433e:	fed71ce3          	bne	a4,a3,80004336 <exec+0x276>
    80004342:	bfc5                	j	80004332 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004344:	4641                	li	a2,16
    80004346:	df843583          	ld	a1,-520(s0)
    8000434a:	158a8513          	addi	a0,s5,344
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	f7c080e7          	jalr	-132(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004356:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000435a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000435e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004362:	058ab783          	ld	a5,88(s5)
    80004366:	e6843703          	ld	a4,-408(s0)
    8000436a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000436c:	058ab783          	ld	a5,88(s5)
    80004370:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004374:	85ea                	mv	a1,s10
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	c9e080e7          	jalr	-866(ra) # 80001014 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000437e:	0004851b          	sext.w	a0,s1
    80004382:	bbd9                	j	80004158 <exec+0x98>
    80004384:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004388:	e0843583          	ld	a1,-504(s0)
    8000438c:	855e                	mv	a0,s7
    8000438e:	ffffd097          	auipc	ra,0xffffd
    80004392:	c86080e7          	jalr	-890(ra) # 80001014 <proc_freepagetable>
  if(ip){
    80004396:	da0497e3          	bnez	s1,80004144 <exec+0x84>
  return -1;
    8000439a:	557d                	li	a0,-1
    8000439c:	bb75                	j	80004158 <exec+0x98>
    8000439e:	e1443423          	sd	s4,-504(s0)
    800043a2:	b7dd                	j	80004388 <exec+0x2c8>
    800043a4:	e1443423          	sd	s4,-504(s0)
    800043a8:	b7c5                	j	80004388 <exec+0x2c8>
    800043aa:	e1443423          	sd	s4,-504(s0)
    800043ae:	bfe9                	j	80004388 <exec+0x2c8>
    800043b0:	e1443423          	sd	s4,-504(s0)
    800043b4:	bfd1                	j	80004388 <exec+0x2c8>
  sz = sz1;
    800043b6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ba:	4481                	li	s1,0
    800043bc:	b7f1                	j	80004388 <exec+0x2c8>
  sz = sz1;
    800043be:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c2:	4481                	li	s1,0
    800043c4:	b7d1                	j	80004388 <exec+0x2c8>
  sz = sz1;
    800043c6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ca:	4481                	li	s1,0
    800043cc:	bf75                	j	80004388 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043ce:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d2:	2b05                	addiw	s6,s6,1
    800043d4:	0389899b          	addiw	s3,s3,56
    800043d8:	e8845783          	lhu	a5,-376(s0)
    800043dc:	e2fb57e3          	bge	s6,a5,8000420a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043e0:	2981                	sext.w	s3,s3
    800043e2:	03800713          	li	a4,56
    800043e6:	86ce                	mv	a3,s3
    800043e8:	e1840613          	addi	a2,s0,-488
    800043ec:	4581                	li	a1,0
    800043ee:	8526                	mv	a0,s1
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	a6e080e7          	jalr	-1426(ra) # 80002e5e <readi>
    800043f8:	03800793          	li	a5,56
    800043fc:	f8f514e3          	bne	a0,a5,80004384 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004400:	e1842783          	lw	a5,-488(s0)
    80004404:	4705                	li	a4,1
    80004406:	fce796e3          	bne	a5,a4,800043d2 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000440a:	e4043903          	ld	s2,-448(s0)
    8000440e:	e3843783          	ld	a5,-456(s0)
    80004412:	f8f966e3          	bltu	s2,a5,8000439e <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004416:	e2843783          	ld	a5,-472(s0)
    8000441a:	993e                	add	s2,s2,a5
    8000441c:	f8f964e3          	bltu	s2,a5,800043a4 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004420:	df043703          	ld	a4,-528(s0)
    80004424:	8ff9                	and	a5,a5,a4
    80004426:	f3d1                	bnez	a5,800043aa <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004428:	e1c42503          	lw	a0,-484(s0)
    8000442c:	00000097          	auipc	ra,0x0
    80004430:	c78080e7          	jalr	-904(ra) # 800040a4 <flags2perm>
    80004434:	86aa                	mv	a3,a0
    80004436:	864a                	mv	a2,s2
    80004438:	85d2                	mv	a1,s4
    8000443a:	855e                	mv	a0,s7
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	4a6080e7          	jalr	1190(ra) # 800008e2 <uvmalloc>
    80004444:	e0a43423          	sd	a0,-504(s0)
    80004448:	d525                	beqz	a0,800043b0 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000444a:	e2843d03          	ld	s10,-472(s0)
    8000444e:	e2042d83          	lw	s11,-480(s0)
    80004452:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004456:	f60c0ce3          	beqz	s8,800043ce <exec+0x30e>
    8000445a:	8a62                	mv	s4,s8
    8000445c:	4901                	li	s2,0
    8000445e:	b369                	j	800041e8 <exec+0x128>

0000000080004460 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004460:	7179                	addi	sp,sp,-48
    80004462:	f406                	sd	ra,40(sp)
    80004464:	f022                	sd	s0,32(sp)
    80004466:	ec26                	sd	s1,24(sp)
    80004468:	e84a                	sd	s2,16(sp)
    8000446a:	1800                	addi	s0,sp,48
    8000446c:	892e                	mv	s2,a1
    8000446e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004470:	fdc40593          	addi	a1,s0,-36
    80004474:	ffffe097          	auipc	ra,0xffffe
    80004478:	b58080e7          	jalr	-1192(ra) # 80001fcc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000447c:	fdc42703          	lw	a4,-36(s0)
    80004480:	47bd                	li	a5,15
    80004482:	02e7eb63          	bltu	a5,a4,800044b8 <argfd+0x58>
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	a2a080e7          	jalr	-1494(ra) # 80000eb0 <myproc>
    8000448e:	fdc42703          	lw	a4,-36(s0)
    80004492:	01a70793          	addi	a5,a4,26
    80004496:	078e                	slli	a5,a5,0x3
    80004498:	953e                	add	a0,a0,a5
    8000449a:	611c                	ld	a5,0(a0)
    8000449c:	c385                	beqz	a5,800044bc <argfd+0x5c>
    return -1;
  if(pfd)
    8000449e:	00090463          	beqz	s2,800044a6 <argfd+0x46>
    *pfd = fd;
    800044a2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044a6:	4501                	li	a0,0
  if(pf)
    800044a8:	c091                	beqz	s1,800044ac <argfd+0x4c>
    *pf = f;
    800044aa:	e09c                	sd	a5,0(s1)
}
    800044ac:	70a2                	ld	ra,40(sp)
    800044ae:	7402                	ld	s0,32(sp)
    800044b0:	64e2                	ld	s1,24(sp)
    800044b2:	6942                	ld	s2,16(sp)
    800044b4:	6145                	addi	sp,sp,48
    800044b6:	8082                	ret
    return -1;
    800044b8:	557d                	li	a0,-1
    800044ba:	bfcd                	j	800044ac <argfd+0x4c>
    800044bc:	557d                	li	a0,-1
    800044be:	b7fd                	j	800044ac <argfd+0x4c>

00000000800044c0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c0:	1101                	addi	sp,sp,-32
    800044c2:	ec06                	sd	ra,24(sp)
    800044c4:	e822                	sd	s0,16(sp)
    800044c6:	e426                	sd	s1,8(sp)
    800044c8:	1000                	addi	s0,sp,32
    800044ca:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	9e4080e7          	jalr	-1564(ra) # 80000eb0 <myproc>
    800044d4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044d6:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd1e0>
    800044da:	4501                	li	a0,0
    800044dc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044de:	6398                	ld	a4,0(a5)
    800044e0:	cb19                	beqz	a4,800044f6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044e2:	2505                	addiw	a0,a0,1
    800044e4:	07a1                	addi	a5,a5,8
    800044e6:	fed51ce3          	bne	a0,a3,800044de <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ea:	557d                	li	a0,-1
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6105                	addi	sp,sp,32
    800044f4:	8082                	ret
      p->ofile[fd] = f;
    800044f6:	01a50793          	addi	a5,a0,26
    800044fa:	078e                	slli	a5,a5,0x3
    800044fc:	963e                	add	a2,a2,a5
    800044fe:	e204                	sd	s1,0(a2)
      return fd;
    80004500:	b7f5                	j	800044ec <fdalloc+0x2c>

0000000080004502 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004502:	715d                	addi	sp,sp,-80
    80004504:	e486                	sd	ra,72(sp)
    80004506:	e0a2                	sd	s0,64(sp)
    80004508:	fc26                	sd	s1,56(sp)
    8000450a:	f84a                	sd	s2,48(sp)
    8000450c:	f44e                	sd	s3,40(sp)
    8000450e:	f052                	sd	s4,32(sp)
    80004510:	ec56                	sd	s5,24(sp)
    80004512:	e85a                	sd	s6,16(sp)
    80004514:	0880                	addi	s0,sp,80
    80004516:	8b2e                	mv	s6,a1
    80004518:	89b2                	mv	s3,a2
    8000451a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000451c:	fb040593          	addi	a1,s0,-80
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	e4e080e7          	jalr	-434(ra) # 8000336e <nameiparent>
    80004528:	84aa                	mv	s1,a0
    8000452a:	16050063          	beqz	a0,8000468a <create+0x188>
    return 0;

  ilock(dp);
    8000452e:	ffffe097          	auipc	ra,0xffffe
    80004532:	67c080e7          	jalr	1660(ra) # 80002baa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004536:	4601                	li	a2,0
    80004538:	fb040593          	addi	a1,s0,-80
    8000453c:	8526                	mv	a0,s1
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	b50080e7          	jalr	-1200(ra) # 8000308e <dirlookup>
    80004546:	8aaa                	mv	s5,a0
    80004548:	c931                	beqz	a0,8000459c <create+0x9a>
    iunlockput(dp);
    8000454a:	8526                	mv	a0,s1
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	8c0080e7          	jalr	-1856(ra) # 80002e0c <iunlockput>
    ilock(ip);
    80004554:	8556                	mv	a0,s5
    80004556:	ffffe097          	auipc	ra,0xffffe
    8000455a:	654080e7          	jalr	1620(ra) # 80002baa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000455e:	000b059b          	sext.w	a1,s6
    80004562:	4789                	li	a5,2
    80004564:	02f59563          	bne	a1,a5,8000458e <create+0x8c>
    80004568:	044ad783          	lhu	a5,68(s5)
    8000456c:	37f9                	addiw	a5,a5,-2
    8000456e:	17c2                	slli	a5,a5,0x30
    80004570:	93c1                	srli	a5,a5,0x30
    80004572:	4705                	li	a4,1
    80004574:	00f76d63          	bltu	a4,a5,8000458e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004578:	8556                	mv	a0,s5
    8000457a:	60a6                	ld	ra,72(sp)
    8000457c:	6406                	ld	s0,64(sp)
    8000457e:	74e2                	ld	s1,56(sp)
    80004580:	7942                	ld	s2,48(sp)
    80004582:	79a2                	ld	s3,40(sp)
    80004584:	7a02                	ld	s4,32(sp)
    80004586:	6ae2                	ld	s5,24(sp)
    80004588:	6b42                	ld	s6,16(sp)
    8000458a:	6161                	addi	sp,sp,80
    8000458c:	8082                	ret
    iunlockput(ip);
    8000458e:	8556                	mv	a0,s5
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	87c080e7          	jalr	-1924(ra) # 80002e0c <iunlockput>
    return 0;
    80004598:	4a81                	li	s5,0
    8000459a:	bff9                	j	80004578 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000459c:	85da                	mv	a1,s6
    8000459e:	4088                	lw	a0,0(s1)
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	46e080e7          	jalr	1134(ra) # 80002a0e <ialloc>
    800045a8:	8a2a                	mv	s4,a0
    800045aa:	c921                	beqz	a0,800045fa <create+0xf8>
  ilock(ip);
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	5fe080e7          	jalr	1534(ra) # 80002baa <ilock>
  ip->major = major;
    800045b4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045b8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045bc:	4785                	li	a5,1
    800045be:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800045c2:	8552                	mv	a0,s4
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	51c080e7          	jalr	1308(ra) # 80002ae0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045cc:	000b059b          	sext.w	a1,s6
    800045d0:	4785                	li	a5,1
    800045d2:	02f58b63          	beq	a1,a5,80004608 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d6:	004a2603          	lw	a2,4(s4)
    800045da:	fb040593          	addi	a1,s0,-80
    800045de:	8526                	mv	a0,s1
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	cbe080e7          	jalr	-834(ra) # 8000329e <dirlink>
    800045e8:	06054f63          	bltz	a0,80004666 <create+0x164>
  iunlockput(dp);
    800045ec:	8526                	mv	a0,s1
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	81e080e7          	jalr	-2018(ra) # 80002e0c <iunlockput>
  return ip;
    800045f6:	8ad2                	mv	s5,s4
    800045f8:	b741                	j	80004578 <create+0x76>
    iunlockput(dp);
    800045fa:	8526                	mv	a0,s1
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	810080e7          	jalr	-2032(ra) # 80002e0c <iunlockput>
    return 0;
    80004604:	8ad2                	mv	s5,s4
    80004606:	bf8d                	j	80004578 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004608:	004a2603          	lw	a2,4(s4)
    8000460c:	00004597          	auipc	a1,0x4
    80004610:	22458593          	addi	a1,a1,548 # 80008830 <syscall_list+0x2a0>
    80004614:	8552                	mv	a0,s4
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	c88080e7          	jalr	-888(ra) # 8000329e <dirlink>
    8000461e:	04054463          	bltz	a0,80004666 <create+0x164>
    80004622:	40d0                	lw	a2,4(s1)
    80004624:	00004597          	auipc	a1,0x4
    80004628:	21458593          	addi	a1,a1,532 # 80008838 <syscall_list+0x2a8>
    8000462c:	8552                	mv	a0,s4
    8000462e:	fffff097          	auipc	ra,0xfffff
    80004632:	c70080e7          	jalr	-912(ra) # 8000329e <dirlink>
    80004636:	02054863          	bltz	a0,80004666 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000463a:	004a2603          	lw	a2,4(s4)
    8000463e:	fb040593          	addi	a1,s0,-80
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	c5a080e7          	jalr	-934(ra) # 8000329e <dirlink>
    8000464c:	00054d63          	bltz	a0,80004666 <create+0x164>
    dp->nlink++;  // for ".."
    80004650:	04a4d783          	lhu	a5,74(s1)
    80004654:	2785                	addiw	a5,a5,1
    80004656:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	484080e7          	jalr	1156(ra) # 80002ae0 <iupdate>
    80004664:	b761                	j	800045ec <create+0xea>
  ip->nlink = 0;
    80004666:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000466a:	8552                	mv	a0,s4
    8000466c:	ffffe097          	auipc	ra,0xffffe
    80004670:	474080e7          	jalr	1140(ra) # 80002ae0 <iupdate>
  iunlockput(ip);
    80004674:	8552                	mv	a0,s4
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	796080e7          	jalr	1942(ra) # 80002e0c <iunlockput>
  iunlockput(dp);
    8000467e:	8526                	mv	a0,s1
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	78c080e7          	jalr	1932(ra) # 80002e0c <iunlockput>
  return 0;
    80004688:	bdc5                	j	80004578 <create+0x76>
    return 0;
    8000468a:	8aaa                	mv	s5,a0
    8000468c:	b5f5                	j	80004578 <create+0x76>

000000008000468e <sys_dup>:
{
    8000468e:	7179                	addi	sp,sp,-48
    80004690:	f406                	sd	ra,40(sp)
    80004692:	f022                	sd	s0,32(sp)
    80004694:	ec26                	sd	s1,24(sp)
    80004696:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004698:	fd840613          	addi	a2,s0,-40
    8000469c:	4581                	li	a1,0
    8000469e:	4501                	li	a0,0
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	dc0080e7          	jalr	-576(ra) # 80004460 <argfd>
    return -1;
    800046a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046aa:	02054363          	bltz	a0,800046d0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046ae:	fd843503          	ld	a0,-40(s0)
    800046b2:	00000097          	auipc	ra,0x0
    800046b6:	e0e080e7          	jalr	-498(ra) # 800044c0 <fdalloc>
    800046ba:	84aa                	mv	s1,a0
    return -1;
    800046bc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046be:	00054963          	bltz	a0,800046d0 <sys_dup+0x42>
  filedup(f);
    800046c2:	fd843503          	ld	a0,-40(s0)
    800046c6:	fffff097          	auipc	ra,0xfffff
    800046ca:	320080e7          	jalr	800(ra) # 800039e6 <filedup>
  return fd;
    800046ce:	87a6                	mv	a5,s1
}
    800046d0:	853e                	mv	a0,a5
    800046d2:	70a2                	ld	ra,40(sp)
    800046d4:	7402                	ld	s0,32(sp)
    800046d6:	64e2                	ld	s1,24(sp)
    800046d8:	6145                	addi	sp,sp,48
    800046da:	8082                	ret

00000000800046dc <sys_read>:
{
    800046dc:	7179                	addi	sp,sp,-48
    800046de:	f406                	sd	ra,40(sp)
    800046e0:	f022                	sd	s0,32(sp)
    800046e2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046e4:	fd840593          	addi	a1,s0,-40
    800046e8:	4505                	li	a0,1
    800046ea:	ffffe097          	auipc	ra,0xffffe
    800046ee:	902080e7          	jalr	-1790(ra) # 80001fec <argaddr>
  argint(2, &n);
    800046f2:	fe440593          	addi	a1,s0,-28
    800046f6:	4509                	li	a0,2
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	8d4080e7          	jalr	-1836(ra) # 80001fcc <argint>
  if(argfd(0, 0, &f) < 0)
    80004700:	fe840613          	addi	a2,s0,-24
    80004704:	4581                	li	a1,0
    80004706:	4501                	li	a0,0
    80004708:	00000097          	auipc	ra,0x0
    8000470c:	d58080e7          	jalr	-680(ra) # 80004460 <argfd>
    80004710:	87aa                	mv	a5,a0
    return -1;
    80004712:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004714:	0007cc63          	bltz	a5,8000472c <sys_read+0x50>
  return fileread(f, p, n);
    80004718:	fe442603          	lw	a2,-28(s0)
    8000471c:	fd843583          	ld	a1,-40(s0)
    80004720:	fe843503          	ld	a0,-24(s0)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	44e080e7          	jalr	1102(ra) # 80003b72 <fileread>
}
    8000472c:	70a2                	ld	ra,40(sp)
    8000472e:	7402                	ld	s0,32(sp)
    80004730:	6145                	addi	sp,sp,48
    80004732:	8082                	ret

0000000080004734 <sys_write>:
{
    80004734:	7179                	addi	sp,sp,-48
    80004736:	f406                	sd	ra,40(sp)
    80004738:	f022                	sd	s0,32(sp)
    8000473a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000473c:	fd840593          	addi	a1,s0,-40
    80004740:	4505                	li	a0,1
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	8aa080e7          	jalr	-1878(ra) # 80001fec <argaddr>
  argint(2, &n);
    8000474a:	fe440593          	addi	a1,s0,-28
    8000474e:	4509                	li	a0,2
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	87c080e7          	jalr	-1924(ra) # 80001fcc <argint>
  if(argfd(0, 0, &f) < 0)
    80004758:	fe840613          	addi	a2,s0,-24
    8000475c:	4581                	li	a1,0
    8000475e:	4501                	li	a0,0
    80004760:	00000097          	auipc	ra,0x0
    80004764:	d00080e7          	jalr	-768(ra) # 80004460 <argfd>
    80004768:	87aa                	mv	a5,a0
    return -1;
    8000476a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000476c:	0007cc63          	bltz	a5,80004784 <sys_write+0x50>
  return filewrite(f, p, n);
    80004770:	fe442603          	lw	a2,-28(s0)
    80004774:	fd843583          	ld	a1,-40(s0)
    80004778:	fe843503          	ld	a0,-24(s0)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	4b8080e7          	jalr	1208(ra) # 80003c34 <filewrite>
}
    80004784:	70a2                	ld	ra,40(sp)
    80004786:	7402                	ld	s0,32(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret

000000008000478c <sys_close>:
{
    8000478c:	1101                	addi	sp,sp,-32
    8000478e:	ec06                	sd	ra,24(sp)
    80004790:	e822                	sd	s0,16(sp)
    80004792:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004794:	fe040613          	addi	a2,s0,-32
    80004798:	fec40593          	addi	a1,s0,-20
    8000479c:	4501                	li	a0,0
    8000479e:	00000097          	auipc	ra,0x0
    800047a2:	cc2080e7          	jalr	-830(ra) # 80004460 <argfd>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a8:	02054463          	bltz	a0,800047d0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	704080e7          	jalr	1796(ra) # 80000eb0 <myproc>
    800047b4:	fec42783          	lw	a5,-20(s0)
    800047b8:	07e9                	addi	a5,a5,26
    800047ba:	078e                	slli	a5,a5,0x3
    800047bc:	97aa                	add	a5,a5,a0
    800047be:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047c2:	fe043503          	ld	a0,-32(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	272080e7          	jalr	626(ra) # 80003a38 <fileclose>
  return 0;
    800047ce:	4781                	li	a5,0
}
    800047d0:	853e                	mv	a0,a5
    800047d2:	60e2                	ld	ra,24(sp)
    800047d4:	6442                	ld	s0,16(sp)
    800047d6:	6105                	addi	sp,sp,32
    800047d8:	8082                	ret

00000000800047da <sys_fstat>:
{
    800047da:	1101                	addi	sp,sp,-32
    800047dc:	ec06                	sd	ra,24(sp)
    800047de:	e822                	sd	s0,16(sp)
    800047e0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047e2:	fe040593          	addi	a1,s0,-32
    800047e6:	4505                	li	a0,1
    800047e8:	ffffe097          	auipc	ra,0xffffe
    800047ec:	804080e7          	jalr	-2044(ra) # 80001fec <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047f0:	fe840613          	addi	a2,s0,-24
    800047f4:	4581                	li	a1,0
    800047f6:	4501                	li	a0,0
    800047f8:	00000097          	auipc	ra,0x0
    800047fc:	c68080e7          	jalr	-920(ra) # 80004460 <argfd>
    80004800:	87aa                	mv	a5,a0
    return -1;
    80004802:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004804:	0007ca63          	bltz	a5,80004818 <sys_fstat+0x3e>
  return filestat(f, st);
    80004808:	fe043583          	ld	a1,-32(s0)
    8000480c:	fe843503          	ld	a0,-24(s0)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	2f0080e7          	jalr	752(ra) # 80003b00 <filestat>
}
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	6105                	addi	sp,sp,32
    8000481e:	8082                	ret

0000000080004820 <sys_link>:
{
    80004820:	7169                	addi	sp,sp,-304
    80004822:	f606                	sd	ra,296(sp)
    80004824:	f222                	sd	s0,288(sp)
    80004826:	ee26                	sd	s1,280(sp)
    80004828:	ea4a                	sd	s2,272(sp)
    8000482a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482c:	08000613          	li	a2,128
    80004830:	ed040593          	addi	a1,s0,-304
    80004834:	4501                	li	a0,0
    80004836:	ffffd097          	auipc	ra,0xffffd
    8000483a:	7d6080e7          	jalr	2006(ra) # 8000200c <argstr>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004840:	10054e63          	bltz	a0,8000495c <sys_link+0x13c>
    80004844:	08000613          	li	a2,128
    80004848:	f5040593          	addi	a1,s0,-176
    8000484c:	4505                	li	a0,1
    8000484e:	ffffd097          	auipc	ra,0xffffd
    80004852:	7be080e7          	jalr	1982(ra) # 8000200c <argstr>
    return -1;
    80004856:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004858:	10054263          	bltz	a0,8000495c <sys_link+0x13c>
  begin_op();
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	d10080e7          	jalr	-752(ra) # 8000356c <begin_op>
  if((ip = namei(old)) == 0){
    80004864:	ed040513          	addi	a0,s0,-304
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	ae8080e7          	jalr	-1304(ra) # 80003350 <namei>
    80004870:	84aa                	mv	s1,a0
    80004872:	c551                	beqz	a0,800048fe <sys_link+0xde>
  ilock(ip);
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	336080e7          	jalr	822(ra) # 80002baa <ilock>
  if(ip->type == T_DIR){
    8000487c:	04449703          	lh	a4,68(s1)
    80004880:	4785                	li	a5,1
    80004882:	08f70463          	beq	a4,a5,8000490a <sys_link+0xea>
  ip->nlink++;
    80004886:	04a4d783          	lhu	a5,74(s1)
    8000488a:	2785                	addiw	a5,a5,1
    8000488c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	24e080e7          	jalr	590(ra) # 80002ae0 <iupdate>
  iunlock(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	3d0080e7          	jalr	976(ra) # 80002c6c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a4:	fd040593          	addi	a1,s0,-48
    800048a8:	f5040513          	addi	a0,s0,-176
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	ac2080e7          	jalr	-1342(ra) # 8000336e <nameiparent>
    800048b4:	892a                	mv	s2,a0
    800048b6:	c935                	beqz	a0,8000492a <sys_link+0x10a>
  ilock(dp);
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	2f2080e7          	jalr	754(ra) # 80002baa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c0:	00092703          	lw	a4,0(s2)
    800048c4:	409c                	lw	a5,0(s1)
    800048c6:	04f71d63          	bne	a4,a5,80004920 <sys_link+0x100>
    800048ca:	40d0                	lw	a2,4(s1)
    800048cc:	fd040593          	addi	a1,s0,-48
    800048d0:	854a                	mv	a0,s2
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	9cc080e7          	jalr	-1588(ra) # 8000329e <dirlink>
    800048da:	04054363          	bltz	a0,80004920 <sys_link+0x100>
  iunlockput(dp);
    800048de:	854a                	mv	a0,s2
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	52c080e7          	jalr	1324(ra) # 80002e0c <iunlockput>
  iput(ip);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	47a080e7          	jalr	1146(ra) # 80002d64 <iput>
  end_op();
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	cfa080e7          	jalr	-774(ra) # 800035ec <end_op>
  return 0;
    800048fa:	4781                	li	a5,0
    800048fc:	a085                	j	8000495c <sys_link+0x13c>
    end_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	cee080e7          	jalr	-786(ra) # 800035ec <end_op>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a891                	j	8000495c <sys_link+0x13c>
    iunlockput(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	500080e7          	jalr	1280(ra) # 80002e0c <iunlockput>
    end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	cd8080e7          	jalr	-808(ra) # 800035ec <end_op>
    return -1;
    8000491c:	57fd                	li	a5,-1
    8000491e:	a83d                	j	8000495c <sys_link+0x13c>
    iunlockput(dp);
    80004920:	854a                	mv	a0,s2
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	4ea080e7          	jalr	1258(ra) # 80002e0c <iunlockput>
  ilock(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	27e080e7          	jalr	638(ra) # 80002baa <ilock>
  ip->nlink--;
    80004934:	04a4d783          	lhu	a5,74(s1)
    80004938:	37fd                	addiw	a5,a5,-1
    8000493a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493e:	8526                	mv	a0,s1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	1a0080e7          	jalr	416(ra) # 80002ae0 <iupdate>
  iunlockput(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	4c2080e7          	jalr	1218(ra) # 80002e0c <iunlockput>
  end_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	c9a080e7          	jalr	-870(ra) # 800035ec <end_op>
  return -1;
    8000495a:	57fd                	li	a5,-1
}
    8000495c:	853e                	mv	a0,a5
    8000495e:	70b2                	ld	ra,296(sp)
    80004960:	7412                	ld	s0,288(sp)
    80004962:	64f2                	ld	s1,280(sp)
    80004964:	6952                	ld	s2,272(sp)
    80004966:	6155                	addi	sp,sp,304
    80004968:	8082                	ret

000000008000496a <sys_unlink>:
{
    8000496a:	7151                	addi	sp,sp,-240
    8000496c:	f586                	sd	ra,232(sp)
    8000496e:	f1a2                	sd	s0,224(sp)
    80004970:	eda6                	sd	s1,216(sp)
    80004972:	e9ca                	sd	s2,208(sp)
    80004974:	e5ce                	sd	s3,200(sp)
    80004976:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004978:	08000613          	li	a2,128
    8000497c:	f3040593          	addi	a1,s0,-208
    80004980:	4501                	li	a0,0
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	68a080e7          	jalr	1674(ra) # 8000200c <argstr>
    8000498a:	18054163          	bltz	a0,80004b0c <sys_unlink+0x1a2>
  begin_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	bde080e7          	jalr	-1058(ra) # 8000356c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004996:	fb040593          	addi	a1,s0,-80
    8000499a:	f3040513          	addi	a0,s0,-208
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	9d0080e7          	jalr	-1584(ra) # 8000336e <nameiparent>
    800049a6:	84aa                	mv	s1,a0
    800049a8:	c979                	beqz	a0,80004a7e <sys_unlink+0x114>
  ilock(dp);
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	200080e7          	jalr	512(ra) # 80002baa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b2:	00004597          	auipc	a1,0x4
    800049b6:	e7e58593          	addi	a1,a1,-386 # 80008830 <syscall_list+0x2a0>
    800049ba:	fb040513          	addi	a0,s0,-80
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	6b6080e7          	jalr	1718(ra) # 80003074 <namecmp>
    800049c6:	14050a63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
    800049ca:	00004597          	auipc	a1,0x4
    800049ce:	e6e58593          	addi	a1,a1,-402 # 80008838 <syscall_list+0x2a8>
    800049d2:	fb040513          	addi	a0,s0,-80
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	69e080e7          	jalr	1694(ra) # 80003074 <namecmp>
    800049de:	12050e63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e2:	f2c40613          	addi	a2,s0,-212
    800049e6:	fb040593          	addi	a1,s0,-80
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	6a2080e7          	jalr	1698(ra) # 8000308e <dirlookup>
    800049f4:	892a                	mv	s2,a0
    800049f6:	12050263          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  ilock(ip);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	1b0080e7          	jalr	432(ra) # 80002baa <ilock>
  if(ip->nlink < 1)
    80004a02:	04a91783          	lh	a5,74(s2)
    80004a06:	08f05263          	blez	a5,80004a8a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a0a:	04491703          	lh	a4,68(s2)
    80004a0e:	4785                	li	a5,1
    80004a10:	08f70563          	beq	a4,a5,80004a9a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a14:	4641                	li	a2,16
    80004a16:	4581                	li	a1,0
    80004a18:	fc040513          	addi	a0,s0,-64
    80004a1c:	ffffb097          	auipc	ra,0xffffb
    80004a20:	75c080e7          	jalr	1884(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a24:	4741                	li	a4,16
    80004a26:	f2c42683          	lw	a3,-212(s0)
    80004a2a:	fc040613          	addi	a2,s0,-64
    80004a2e:	4581                	li	a1,0
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	524080e7          	jalr	1316(ra) # 80002f56 <writei>
    80004a3a:	47c1                	li	a5,16
    80004a3c:	0af51563          	bne	a0,a5,80004ae6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a40:	04491703          	lh	a4,68(s2)
    80004a44:	4785                	li	a5,1
    80004a46:	0af70863          	beq	a4,a5,80004af6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	3c0080e7          	jalr	960(ra) # 80002e0c <iunlockput>
  ip->nlink--;
    80004a54:	04a95783          	lhu	a5,74(s2)
    80004a58:	37fd                	addiw	a5,a5,-1
    80004a5a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	080080e7          	jalr	128(ra) # 80002ae0 <iupdate>
  iunlockput(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3a2080e7          	jalr	930(ra) # 80002e0c <iunlockput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	b7a080e7          	jalr	-1158(ra) # 800035ec <end_op>
  return 0;
    80004a7a:	4501                	li	a0,0
    80004a7c:	a84d                	j	80004b2e <sys_unlink+0x1c4>
    end_op();
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	b6e080e7          	jalr	-1170(ra) # 800035ec <end_op>
    return -1;
    80004a86:	557d                	li	a0,-1
    80004a88:	a05d                	j	80004b2e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a8a:	00004517          	auipc	a0,0x4
    80004a8e:	db650513          	addi	a0,a0,-586 # 80008840 <syscall_list+0x2b0>
    80004a92:	00001097          	auipc	ra,0x1
    80004a96:	210080e7          	jalr	528(ra) # 80005ca2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9a:	04c92703          	lw	a4,76(s2)
    80004a9e:	02000793          	li	a5,32
    80004aa2:	f6e7f9e3          	bgeu	a5,a4,80004a14 <sys_unlink+0xaa>
    80004aa6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aaa:	4741                	li	a4,16
    80004aac:	86ce                	mv	a3,s3
    80004aae:	f1840613          	addi	a2,s0,-232
    80004ab2:	4581                	li	a1,0
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	3a8080e7          	jalr	936(ra) # 80002e5e <readi>
    80004abe:	47c1                	li	a5,16
    80004ac0:	00f51b63          	bne	a0,a5,80004ad6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ac4:	f1845783          	lhu	a5,-232(s0)
    80004ac8:	e7a1                	bnez	a5,80004b10 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aca:	29c1                	addiw	s3,s3,16
    80004acc:	04c92783          	lw	a5,76(s2)
    80004ad0:	fcf9ede3          	bltu	s3,a5,80004aaa <sys_unlink+0x140>
    80004ad4:	b781                	j	80004a14 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ad6:	00004517          	auipc	a0,0x4
    80004ada:	d8250513          	addi	a0,a0,-638 # 80008858 <syscall_list+0x2c8>
    80004ade:	00001097          	auipc	ra,0x1
    80004ae2:	1c4080e7          	jalr	452(ra) # 80005ca2 <panic>
    panic("unlink: writei");
    80004ae6:	00004517          	auipc	a0,0x4
    80004aea:	d8a50513          	addi	a0,a0,-630 # 80008870 <syscall_list+0x2e0>
    80004aee:	00001097          	auipc	ra,0x1
    80004af2:	1b4080e7          	jalr	436(ra) # 80005ca2 <panic>
    dp->nlink--;
    80004af6:	04a4d783          	lhu	a5,74(s1)
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	fde080e7          	jalr	-34(ra) # 80002ae0 <iupdate>
    80004b0a:	b781                	j	80004a4a <sys_unlink+0xe0>
    return -1;
    80004b0c:	557d                	li	a0,-1
    80004b0e:	a005                	j	80004b2e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b10:	854a                	mv	a0,s2
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	2fa080e7          	jalr	762(ra) # 80002e0c <iunlockput>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	2f0080e7          	jalr	752(ra) # 80002e0c <iunlockput>
  end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	ac8080e7          	jalr	-1336(ra) # 800035ec <end_op>
  return -1;
    80004b2c:	557d                	li	a0,-1
}
    80004b2e:	70ae                	ld	ra,232(sp)
    80004b30:	740e                	ld	s0,224(sp)
    80004b32:	64ee                	ld	s1,216(sp)
    80004b34:	694e                	ld	s2,208(sp)
    80004b36:	69ae                	ld	s3,200(sp)
    80004b38:	616d                	addi	sp,sp,240
    80004b3a:	8082                	ret

0000000080004b3c <sys_open>:

uint64
sys_open(void)
{
    80004b3c:	7131                	addi	sp,sp,-192
    80004b3e:	fd06                	sd	ra,184(sp)
    80004b40:	f922                	sd	s0,176(sp)
    80004b42:	f526                	sd	s1,168(sp)
    80004b44:	f14a                	sd	s2,160(sp)
    80004b46:	ed4e                	sd	s3,152(sp)
    80004b48:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b4a:	f4c40593          	addi	a1,s0,-180
    80004b4e:	4505                	li	a0,1
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	47c080e7          	jalr	1148(ra) # 80001fcc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b58:	08000613          	li	a2,128
    80004b5c:	f5040593          	addi	a1,s0,-176
    80004b60:	4501                	li	a0,0
    80004b62:	ffffd097          	auipc	ra,0xffffd
    80004b66:	4aa080e7          	jalr	1194(ra) # 8000200c <argstr>
    80004b6a:	87aa                	mv	a5,a0
    return -1;
    80004b6c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b6e:	0a07c963          	bltz	a5,80004c20 <sys_open+0xe4>

  begin_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	9fa080e7          	jalr	-1542(ra) # 8000356c <begin_op>

  if(omode & O_CREATE){
    80004b7a:	f4c42783          	lw	a5,-180(s0)
    80004b7e:	2007f793          	andi	a5,a5,512
    80004b82:	cfc5                	beqz	a5,80004c3a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b84:	4681                	li	a3,0
    80004b86:	4601                	li	a2,0
    80004b88:	4589                	li	a1,2
    80004b8a:	f5040513          	addi	a0,s0,-176
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	974080e7          	jalr	-1676(ra) # 80004502 <create>
    80004b96:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b98:	c959                	beqz	a0,80004c2e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b9a:	04449703          	lh	a4,68(s1)
    80004b9e:	478d                	li	a5,3
    80004ba0:	00f71763          	bne	a4,a5,80004bae <sys_open+0x72>
    80004ba4:	0464d703          	lhu	a4,70(s1)
    80004ba8:	47a5                	li	a5,9
    80004baa:	0ce7ed63          	bltu	a5,a4,80004c84 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	dce080e7          	jalr	-562(ra) # 8000397c <filealloc>
    80004bb6:	89aa                	mv	s3,a0
    80004bb8:	10050363          	beqz	a0,80004cbe <sys_open+0x182>
    80004bbc:	00000097          	auipc	ra,0x0
    80004bc0:	904080e7          	jalr	-1788(ra) # 800044c0 <fdalloc>
    80004bc4:	892a                	mv	s2,a0
    80004bc6:	0e054763          	bltz	a0,80004cb4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bca:	04449703          	lh	a4,68(s1)
    80004bce:	478d                	li	a5,3
    80004bd0:	0cf70563          	beq	a4,a5,80004c9a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bd4:	4789                	li	a5,2
    80004bd6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bda:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bde:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004be2:	f4c42783          	lw	a5,-180(s0)
    80004be6:	0017c713          	xori	a4,a5,1
    80004bea:	8b05                	andi	a4,a4,1
    80004bec:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bf0:	0037f713          	andi	a4,a5,3
    80004bf4:	00e03733          	snez	a4,a4
    80004bf8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bfc:	4007f793          	andi	a5,a5,1024
    80004c00:	c791                	beqz	a5,80004c0c <sys_open+0xd0>
    80004c02:	04449703          	lh	a4,68(s1)
    80004c06:	4789                	li	a5,2
    80004c08:	0af70063          	beq	a4,a5,80004ca8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	05e080e7          	jalr	94(ra) # 80002c6c <iunlock>
  end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	9d6080e7          	jalr	-1578(ra) # 800035ec <end_op>

  return fd;
    80004c1e:	854a                	mv	a0,s2
}
    80004c20:	70ea                	ld	ra,184(sp)
    80004c22:	744a                	ld	s0,176(sp)
    80004c24:	74aa                	ld	s1,168(sp)
    80004c26:	790a                	ld	s2,160(sp)
    80004c28:	69ea                	ld	s3,152(sp)
    80004c2a:	6129                	addi	sp,sp,192
    80004c2c:	8082                	ret
      end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	9be080e7          	jalr	-1602(ra) # 800035ec <end_op>
      return -1;
    80004c36:	557d                	li	a0,-1
    80004c38:	b7e5                	j	80004c20 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c3a:	f5040513          	addi	a0,s0,-176
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	712080e7          	jalr	1810(ra) # 80003350 <namei>
    80004c46:	84aa                	mv	s1,a0
    80004c48:	c905                	beqz	a0,80004c78 <sys_open+0x13c>
    ilock(ip);
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	f60080e7          	jalr	-160(ra) # 80002baa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c52:	04449703          	lh	a4,68(s1)
    80004c56:	4785                	li	a5,1
    80004c58:	f4f711e3          	bne	a4,a5,80004b9a <sys_open+0x5e>
    80004c5c:	f4c42783          	lw	a5,-180(s0)
    80004c60:	d7b9                	beqz	a5,80004bae <sys_open+0x72>
      iunlockput(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	1a8080e7          	jalr	424(ra) # 80002e0c <iunlockput>
      end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	980080e7          	jalr	-1664(ra) # 800035ec <end_op>
      return -1;
    80004c74:	557d                	li	a0,-1
    80004c76:	b76d                	j	80004c20 <sys_open+0xe4>
      end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	974080e7          	jalr	-1676(ra) # 800035ec <end_op>
      return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	bf79                	j	80004c20 <sys_open+0xe4>
    iunlockput(ip);
    80004c84:	8526                	mv	a0,s1
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	186080e7          	jalr	390(ra) # 80002e0c <iunlockput>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	95e080e7          	jalr	-1698(ra) # 800035ec <end_op>
    return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	b761                	j	80004c20 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c9a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c9e:	04649783          	lh	a5,70(s1)
    80004ca2:	02f99223          	sh	a5,36(s3)
    80004ca6:	bf25                	j	80004bde <sys_open+0xa2>
    itrunc(ip);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	00e080e7          	jalr	14(ra) # 80002cb8 <itrunc>
    80004cb2:	bfa9                	j	80004c0c <sys_open+0xd0>
      fileclose(f);
    80004cb4:	854e                	mv	a0,s3
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	d82080e7          	jalr	-638(ra) # 80003a38 <fileclose>
    iunlockput(ip);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	14c080e7          	jalr	332(ra) # 80002e0c <iunlockput>
    end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	924080e7          	jalr	-1756(ra) # 800035ec <end_op>
    return -1;
    80004cd0:	557d                	li	a0,-1
    80004cd2:	b7b9                	j	80004c20 <sys_open+0xe4>

0000000080004cd4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cd4:	7175                	addi	sp,sp,-144
    80004cd6:	e506                	sd	ra,136(sp)
    80004cd8:	e122                	sd	s0,128(sp)
    80004cda:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	890080e7          	jalr	-1904(ra) # 8000356c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ce4:	08000613          	li	a2,128
    80004ce8:	f7040593          	addi	a1,s0,-144
    80004cec:	4501                	li	a0,0
    80004cee:	ffffd097          	auipc	ra,0xffffd
    80004cf2:	31e080e7          	jalr	798(ra) # 8000200c <argstr>
    80004cf6:	02054963          	bltz	a0,80004d28 <sys_mkdir+0x54>
    80004cfa:	4681                	li	a3,0
    80004cfc:	4601                	li	a2,0
    80004cfe:	4585                	li	a1,1
    80004d00:	f7040513          	addi	a0,s0,-144
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	7fe080e7          	jalr	2046(ra) # 80004502 <create>
    80004d0c:	cd11                	beqz	a0,80004d28 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	0fe080e7          	jalr	254(ra) # 80002e0c <iunlockput>
  end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	8d6080e7          	jalr	-1834(ra) # 800035ec <end_op>
  return 0;
    80004d1e:	4501                	li	a0,0
}
    80004d20:	60aa                	ld	ra,136(sp)
    80004d22:	640a                	ld	s0,128(sp)
    80004d24:	6149                	addi	sp,sp,144
    80004d26:	8082                	ret
    end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	8c4080e7          	jalr	-1852(ra) # 800035ec <end_op>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	b7fd                	j	80004d20 <sys_mkdir+0x4c>

0000000080004d34 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d34:	7135                	addi	sp,sp,-160
    80004d36:	ed06                	sd	ra,152(sp)
    80004d38:	e922                	sd	s0,144(sp)
    80004d3a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	830080e7          	jalr	-2000(ra) # 8000356c <begin_op>
  argint(1, &major);
    80004d44:	f6c40593          	addi	a1,s0,-148
    80004d48:	4505                	li	a0,1
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	282080e7          	jalr	642(ra) # 80001fcc <argint>
  argint(2, &minor);
    80004d52:	f6840593          	addi	a1,s0,-152
    80004d56:	4509                	li	a0,2
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	274080e7          	jalr	628(ra) # 80001fcc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d60:	08000613          	li	a2,128
    80004d64:	f7040593          	addi	a1,s0,-144
    80004d68:	4501                	li	a0,0
    80004d6a:	ffffd097          	auipc	ra,0xffffd
    80004d6e:	2a2080e7          	jalr	674(ra) # 8000200c <argstr>
    80004d72:	02054b63          	bltz	a0,80004da8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d76:	f6841683          	lh	a3,-152(s0)
    80004d7a:	f6c41603          	lh	a2,-148(s0)
    80004d7e:	458d                	li	a1,3
    80004d80:	f7040513          	addi	a0,s0,-144
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	77e080e7          	jalr	1918(ra) # 80004502 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d8c:	cd11                	beqz	a0,80004da8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	07e080e7          	jalr	126(ra) # 80002e0c <iunlockput>
  end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	856080e7          	jalr	-1962(ra) # 800035ec <end_op>
  return 0;
    80004d9e:	4501                	li	a0,0
}
    80004da0:	60ea                	ld	ra,152(sp)
    80004da2:	644a                	ld	s0,144(sp)
    80004da4:	610d                	addi	sp,sp,160
    80004da6:	8082                	ret
    end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	844080e7          	jalr	-1980(ra) # 800035ec <end_op>
    return -1;
    80004db0:	557d                	li	a0,-1
    80004db2:	b7fd                	j	80004da0 <sys_mknod+0x6c>

0000000080004db4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004db4:	7135                	addi	sp,sp,-160
    80004db6:	ed06                	sd	ra,152(sp)
    80004db8:	e922                	sd	s0,144(sp)
    80004dba:	e526                	sd	s1,136(sp)
    80004dbc:	e14a                	sd	s2,128(sp)
    80004dbe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dc0:	ffffc097          	auipc	ra,0xffffc
    80004dc4:	0f0080e7          	jalr	240(ra) # 80000eb0 <myproc>
    80004dc8:	892a                	mv	s2,a0
  
  begin_op();
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	7a2080e7          	jalr	1954(ra) # 8000356c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dd2:	08000613          	li	a2,128
    80004dd6:	f6040593          	addi	a1,s0,-160
    80004dda:	4501                	li	a0,0
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	230080e7          	jalr	560(ra) # 8000200c <argstr>
    80004de4:	04054b63          	bltz	a0,80004e3a <sys_chdir+0x86>
    80004de8:	f6040513          	addi	a0,s0,-160
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	564080e7          	jalr	1380(ra) # 80003350 <namei>
    80004df4:	84aa                	mv	s1,a0
    80004df6:	c131                	beqz	a0,80004e3a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	db2080e7          	jalr	-590(ra) # 80002baa <ilock>
  if(ip->type != T_DIR){
    80004e00:	04449703          	lh	a4,68(s1)
    80004e04:	4785                	li	a5,1
    80004e06:	04f71063          	bne	a4,a5,80004e46 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	e60080e7          	jalr	-416(ra) # 80002c6c <iunlock>
  iput(p->cwd);
    80004e14:	15093503          	ld	a0,336(s2)
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	f4c080e7          	jalr	-180(ra) # 80002d64 <iput>
  end_op();
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	7cc080e7          	jalr	1996(ra) # 800035ec <end_op>
  p->cwd = ip;
    80004e28:	14993823          	sd	s1,336(s2)
  return 0;
    80004e2c:	4501                	li	a0,0
}
    80004e2e:	60ea                	ld	ra,152(sp)
    80004e30:	644a                	ld	s0,144(sp)
    80004e32:	64aa                	ld	s1,136(sp)
    80004e34:	690a                	ld	s2,128(sp)
    80004e36:	610d                	addi	sp,sp,160
    80004e38:	8082                	ret
    end_op();
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	7b2080e7          	jalr	1970(ra) # 800035ec <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b7ed                	j	80004e2e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	fc4080e7          	jalr	-60(ra) # 80002e0c <iunlockput>
    end_op();
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	79c080e7          	jalr	1948(ra) # 800035ec <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	bfd1                	j	80004e2e <sys_chdir+0x7a>

0000000080004e5c <sys_exec>:

uint64
sys_exec(void)
{
    80004e5c:	7145                	addi	sp,sp,-464
    80004e5e:	e786                	sd	ra,456(sp)
    80004e60:	e3a2                	sd	s0,448(sp)
    80004e62:	ff26                	sd	s1,440(sp)
    80004e64:	fb4a                	sd	s2,432(sp)
    80004e66:	f74e                	sd	s3,424(sp)
    80004e68:	f352                	sd	s4,416(sp)
    80004e6a:	ef56                	sd	s5,408(sp)
    80004e6c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e6e:	e3840593          	addi	a1,s0,-456
    80004e72:	4505                	li	a0,1
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	178080e7          	jalr	376(ra) # 80001fec <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e7c:	08000613          	li	a2,128
    80004e80:	f4040593          	addi	a1,s0,-192
    80004e84:	4501                	li	a0,0
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	186080e7          	jalr	390(ra) # 8000200c <argstr>
    80004e8e:	87aa                	mv	a5,a0
    return -1;
    80004e90:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e92:	0c07c263          	bltz	a5,80004f56 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e96:	10000613          	li	a2,256
    80004e9a:	4581                	li	a1,0
    80004e9c:	e4040513          	addi	a0,s0,-448
    80004ea0:	ffffb097          	auipc	ra,0xffffb
    80004ea4:	2d8080e7          	jalr	728(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ea8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eac:	89a6                	mv	s3,s1
    80004eae:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eb0:	02000a13          	li	s4,32
    80004eb4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eb8:	00391513          	slli	a0,s2,0x3
    80004ebc:	e3040593          	addi	a1,s0,-464
    80004ec0:	e3843783          	ld	a5,-456(s0)
    80004ec4:	953e                	add	a0,a0,a5
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	068080e7          	jalr	104(ra) # 80001f2e <fetchaddr>
    80004ece:	02054a63          	bltz	a0,80004f02 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ed2:	e3043783          	ld	a5,-464(s0)
    80004ed6:	c3b9                	beqz	a5,80004f1c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ed8:	ffffb097          	auipc	ra,0xffffb
    80004edc:	240080e7          	jalr	576(ra) # 80000118 <kalloc>
    80004ee0:	85aa                	mv	a1,a0
    80004ee2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ee6:	cd11                	beqz	a0,80004f02 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ee8:	6605                	lui	a2,0x1
    80004eea:	e3043503          	ld	a0,-464(s0)
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	092080e7          	jalr	146(ra) # 80001f80 <fetchstr>
    80004ef6:	00054663          	bltz	a0,80004f02 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004efa:	0905                	addi	s2,s2,1
    80004efc:	09a1                	addi	s3,s3,8
    80004efe:	fb491be3          	bne	s2,s4,80004eb4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f02:	10048913          	addi	s2,s1,256
    80004f06:	6088                	ld	a0,0(s1)
    80004f08:	c531                	beqz	a0,80004f54 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f0a:	ffffb097          	auipc	ra,0xffffb
    80004f0e:	112080e7          	jalr	274(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f12:	04a1                	addi	s1,s1,8
    80004f14:	ff2499e3          	bne	s1,s2,80004f06 <sys_exec+0xaa>
  return -1;
    80004f18:	557d                	li	a0,-1
    80004f1a:	a835                	j	80004f56 <sys_exec+0xfa>
      argv[i] = 0;
    80004f1c:	0a8e                	slli	s5,s5,0x3
    80004f1e:	fc040793          	addi	a5,s0,-64
    80004f22:	9abe                	add	s5,s5,a5
    80004f24:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f28:	e4040593          	addi	a1,s0,-448
    80004f2c:	f4040513          	addi	a0,s0,-192
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	190080e7          	jalr	400(ra) # 800040c0 <exec>
    80004f38:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3a:	10048993          	addi	s3,s1,256
    80004f3e:	6088                	ld	a0,0(s1)
    80004f40:	c901                	beqz	a0,80004f50 <sys_exec+0xf4>
    kfree(argv[i]);
    80004f42:	ffffb097          	auipc	ra,0xffffb
    80004f46:	0da080e7          	jalr	218(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4a:	04a1                	addi	s1,s1,8
    80004f4c:	ff3499e3          	bne	s1,s3,80004f3e <sys_exec+0xe2>
  return ret;
    80004f50:	854a                	mv	a0,s2
    80004f52:	a011                	j	80004f56 <sys_exec+0xfa>
  return -1;
    80004f54:	557d                	li	a0,-1
}
    80004f56:	60be                	ld	ra,456(sp)
    80004f58:	641e                	ld	s0,448(sp)
    80004f5a:	74fa                	ld	s1,440(sp)
    80004f5c:	795a                	ld	s2,432(sp)
    80004f5e:	79ba                	ld	s3,424(sp)
    80004f60:	7a1a                	ld	s4,416(sp)
    80004f62:	6afa                	ld	s5,408(sp)
    80004f64:	6179                	addi	sp,sp,464
    80004f66:	8082                	ret

0000000080004f68 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f68:	7139                	addi	sp,sp,-64
    80004f6a:	fc06                	sd	ra,56(sp)
    80004f6c:	f822                	sd	s0,48(sp)
    80004f6e:	f426                	sd	s1,40(sp)
    80004f70:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	f3e080e7          	jalr	-194(ra) # 80000eb0 <myproc>
    80004f7a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f7c:	fd840593          	addi	a1,s0,-40
    80004f80:	4501                	li	a0,0
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	06a080e7          	jalr	106(ra) # 80001fec <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f8a:	fc840593          	addi	a1,s0,-56
    80004f8e:	fd040513          	addi	a0,s0,-48
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	dd6080e7          	jalr	-554(ra) # 80003d68 <pipealloc>
    return -1;
    80004f9a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f9c:	0c054463          	bltz	a0,80005064 <sys_pipe+0xfc>
  fd0 = -1;
    80004fa0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fa4:	fd043503          	ld	a0,-48(s0)
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	518080e7          	jalr	1304(ra) # 800044c0 <fdalloc>
    80004fb0:	fca42223          	sw	a0,-60(s0)
    80004fb4:	08054b63          	bltz	a0,8000504a <sys_pipe+0xe2>
    80004fb8:	fc843503          	ld	a0,-56(s0)
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	504080e7          	jalr	1284(ra) # 800044c0 <fdalloc>
    80004fc4:	fca42023          	sw	a0,-64(s0)
    80004fc8:	06054863          	bltz	a0,80005038 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fcc:	4691                	li	a3,4
    80004fce:	fc440613          	addi	a2,s0,-60
    80004fd2:	fd843583          	ld	a1,-40(s0)
    80004fd6:	68a8                	ld	a0,80(s1)
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	b62080e7          	jalr	-1182(ra) # 80000b3a <copyout>
    80004fe0:	02054063          	bltz	a0,80005000 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fe4:	4691                	li	a3,4
    80004fe6:	fc040613          	addi	a2,s0,-64
    80004fea:	fd843583          	ld	a1,-40(s0)
    80004fee:	0591                	addi	a1,a1,4
    80004ff0:	68a8                	ld	a0,80(s1)
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	b48080e7          	jalr	-1208(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ffa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ffc:	06055463          	bgez	a0,80005064 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005000:	fc442783          	lw	a5,-60(s0)
    80005004:	07e9                	addi	a5,a5,26
    80005006:	078e                	slli	a5,a5,0x3
    80005008:	97a6                	add	a5,a5,s1
    8000500a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000500e:	fc042503          	lw	a0,-64(s0)
    80005012:	0569                	addi	a0,a0,26
    80005014:	050e                	slli	a0,a0,0x3
    80005016:	94aa                	add	s1,s1,a0
    80005018:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000501c:	fd043503          	ld	a0,-48(s0)
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	a18080e7          	jalr	-1512(ra) # 80003a38 <fileclose>
    fileclose(wf);
    80005028:	fc843503          	ld	a0,-56(s0)
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	a0c080e7          	jalr	-1524(ra) # 80003a38 <fileclose>
    return -1;
    80005034:	57fd                	li	a5,-1
    80005036:	a03d                	j	80005064 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005038:	fc442783          	lw	a5,-60(s0)
    8000503c:	0007c763          	bltz	a5,8000504a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005040:	07e9                	addi	a5,a5,26
    80005042:	078e                	slli	a5,a5,0x3
    80005044:	94be                	add	s1,s1,a5
    80005046:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000504a:	fd043503          	ld	a0,-48(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	9ea080e7          	jalr	-1558(ra) # 80003a38 <fileclose>
    fileclose(wf);
    80005056:	fc843503          	ld	a0,-56(s0)
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	9de080e7          	jalr	-1570(ra) # 80003a38 <fileclose>
    return -1;
    80005062:	57fd                	li	a5,-1
}
    80005064:	853e                	mv	a0,a5
    80005066:	70e2                	ld	ra,56(sp)
    80005068:	7442                	ld	s0,48(sp)
    8000506a:	74a2                	ld	s1,40(sp)
    8000506c:	6121                	addi	sp,sp,64
    8000506e:	8082                	ret

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	d4bfc0ef          	jal	ra,80001dfa <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e422                	sd	s0,8(sp)
    8000512e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005130:	0c0007b7          	lui	a5,0xc000
    80005134:	4705                	li	a4,1
    80005136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005138:	c3d8                	sw	a4,4(a5)
}
    8000513a:	6422                	ld	s0,8(sp)
    8000513c:	0141                	addi	sp,sp,16
    8000513e:	8082                	ret

0000000080005140 <plicinithart>:

void
plicinithart(void)
{
    80005140:	1141                	addi	sp,sp,-16
    80005142:	e406                	sd	ra,8(sp)
    80005144:	e022                	sd	s0,0(sp)
    80005146:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d3c080e7          	jalr	-708(ra) # 80000e84 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005150:	0085171b          	slliw	a4,a0,0x8
    80005154:	0c0027b7          	lui	a5,0xc002
    80005158:	97ba                	add	a5,a5,a4
    8000515a:	40200713          	li	a4,1026
    8000515e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005162:	00d5151b          	slliw	a0,a0,0xd
    80005166:	0c2017b7          	lui	a5,0xc201
    8000516a:	953e                	add	a0,a0,a5
    8000516c:	00052023          	sw	zero,0(a0)
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret

0000000080005178 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005178:	1141                	addi	sp,sp,-16
    8000517a:	e406                	sd	ra,8(sp)
    8000517c:	e022                	sd	s0,0(sp)
    8000517e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	d04080e7          	jalr	-764(ra) # 80000e84 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005188:	00d5179b          	slliw	a5,a0,0xd
    8000518c:	0c201537          	lui	a0,0xc201
    80005190:	953e                	add	a0,a0,a5
  return irq;
}
    80005192:	4148                	lw	a0,4(a0)
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000519c:	1101                	addi	sp,sp,-32
    8000519e:	ec06                	sd	ra,24(sp)
    800051a0:	e822                	sd	s0,16(sp)
    800051a2:	e426                	sd	s1,8(sp)
    800051a4:	1000                	addi	s0,sp,32
    800051a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	cdc080e7          	jalr	-804(ra) # 80000e84 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051b0:	00d5151b          	slliw	a0,a0,0xd
    800051b4:	0c2017b7          	lui	a5,0xc201
    800051b8:	97aa                	add	a5,a5,a0
    800051ba:	c3c4                	sw	s1,4(a5)
}
    800051bc:	60e2                	ld	ra,24(sp)
    800051be:	6442                	ld	s0,16(sp)
    800051c0:	64a2                	ld	s1,8(sp)
    800051c2:	6105                	addi	sp,sp,32
    800051c4:	8082                	ret

00000000800051c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051c6:	1141                	addi	sp,sp,-16
    800051c8:	e406                	sd	ra,8(sp)
    800051ca:	e022                	sd	s0,0(sp)
    800051cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ce:	479d                	li	a5,7
    800051d0:	04a7cc63          	blt	a5,a0,80005228 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051d4:	00015797          	auipc	a5,0x15
    800051d8:	99c78793          	addi	a5,a5,-1636 # 80019b70 <disk>
    800051dc:	97aa                	add	a5,a5,a0
    800051de:	0187c783          	lbu	a5,24(a5)
    800051e2:	ebb9                	bnez	a5,80005238 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051e4:	00451613          	slli	a2,a0,0x4
    800051e8:	00015797          	auipc	a5,0x15
    800051ec:	98878793          	addi	a5,a5,-1656 # 80019b70 <disk>
    800051f0:	6394                	ld	a3,0(a5)
    800051f2:	96b2                	add	a3,a3,a2
    800051f4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051f8:	6398                	ld	a4,0(a5)
    800051fa:	9732                	add	a4,a4,a2
    800051fc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005200:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005204:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005208:	953e                	add	a0,a0,a5
    8000520a:	4785                	li	a5,1
    8000520c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005210:	00015517          	auipc	a0,0x15
    80005214:	97850513          	addi	a0,a0,-1672 # 80019b88 <disk+0x18>
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	3ac080e7          	jalr	940(ra) # 800015c4 <wakeup>
}
    80005220:	60a2                	ld	ra,8(sp)
    80005222:	6402                	ld	s0,0(sp)
    80005224:	0141                	addi	sp,sp,16
    80005226:	8082                	ret
    panic("free_desc 1");
    80005228:	00003517          	auipc	a0,0x3
    8000522c:	65850513          	addi	a0,a0,1624 # 80008880 <syscall_list+0x2f0>
    80005230:	00001097          	auipc	ra,0x1
    80005234:	a72080e7          	jalr	-1422(ra) # 80005ca2 <panic>
    panic("free_desc 2");
    80005238:	00003517          	auipc	a0,0x3
    8000523c:	65850513          	addi	a0,a0,1624 # 80008890 <syscall_list+0x300>
    80005240:	00001097          	auipc	ra,0x1
    80005244:	a62080e7          	jalr	-1438(ra) # 80005ca2 <panic>

0000000080005248 <virtio_disk_init>:
{
    80005248:	1101                	addi	sp,sp,-32
    8000524a:	ec06                	sd	ra,24(sp)
    8000524c:	e822                	sd	s0,16(sp)
    8000524e:	e426                	sd	s1,8(sp)
    80005250:	e04a                	sd	s2,0(sp)
    80005252:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005254:	00003597          	auipc	a1,0x3
    80005258:	64c58593          	addi	a1,a1,1612 # 800088a0 <syscall_list+0x310>
    8000525c:	00015517          	auipc	a0,0x15
    80005260:	a3c50513          	addi	a0,a0,-1476 # 80019c98 <disk+0x128>
    80005264:	00001097          	auipc	ra,0x1
    80005268:	ef8080e7          	jalr	-264(ra) # 8000615c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000526c:	100017b7          	lui	a5,0x10001
    80005270:	4398                	lw	a4,0(a5)
    80005272:	2701                	sext.w	a4,a4
    80005274:	747277b7          	lui	a5,0x74727
    80005278:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000527c:	14f71e63          	bne	a4,a5,800053d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005280:	100017b7          	lui	a5,0x10001
    80005284:	43dc                	lw	a5,4(a5)
    80005286:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005288:	4709                	li	a4,2
    8000528a:	14e79763          	bne	a5,a4,800053d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000528e:	100017b7          	lui	a5,0x10001
    80005292:	479c                	lw	a5,8(a5)
    80005294:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005296:	14e79163          	bne	a5,a4,800053d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000529a:	100017b7          	lui	a5,0x10001
    8000529e:	47d8                	lw	a4,12(a5)
    800052a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a2:	554d47b7          	lui	a5,0x554d4
    800052a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052aa:	12f71763          	bne	a4,a5,800053d8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ae:	100017b7          	lui	a5,0x10001
    800052b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b6:	4705                	li	a4,1
    800052b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ba:	470d                	li	a4,3
    800052bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052be:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052c0:	c7ffe737          	lui	a4,0xc7ffe
    800052c4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc86f>
    800052c8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052ca:	2701                	sext.w	a4,a4
    800052cc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ce:	472d                	li	a4,11
    800052d0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052d2:	0707a903          	lw	s2,112(a5)
    800052d6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052d8:	00897793          	andi	a5,s2,8
    800052dc:	10078663          	beqz	a5,800053e8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e0:	100017b7          	lui	a5,0x10001
    800052e4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052e8:	43fc                	lw	a5,68(a5)
    800052ea:	2781                	sext.w	a5,a5
    800052ec:	10079663          	bnez	a5,800053f8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052f0:	100017b7          	lui	a5,0x10001
    800052f4:	5bdc                	lw	a5,52(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052f8:	10078863          	beqz	a5,80005408 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800052fc:	471d                	li	a4,7
    800052fe:	10f77d63          	bgeu	a4,a5,80005418 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005302:	ffffb097          	auipc	ra,0xffffb
    80005306:	e16080e7          	jalr	-490(ra) # 80000118 <kalloc>
    8000530a:	00015497          	auipc	s1,0x15
    8000530e:	86648493          	addi	s1,s1,-1946 # 80019b70 <disk>
    80005312:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	e04080e7          	jalr	-508(ra) # 80000118 <kalloc>
    8000531c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000531e:	ffffb097          	auipc	ra,0xffffb
    80005322:	dfa080e7          	jalr	-518(ra) # 80000118 <kalloc>
    80005326:	87aa                	mv	a5,a0
    80005328:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000532a:	6088                	ld	a0,0(s1)
    8000532c:	cd75                	beqz	a0,80005428 <virtio_disk_init+0x1e0>
    8000532e:	00015717          	auipc	a4,0x15
    80005332:	84a73703          	ld	a4,-1974(a4) # 80019b78 <disk+0x8>
    80005336:	cb6d                	beqz	a4,80005428 <virtio_disk_init+0x1e0>
    80005338:	cbe5                	beqz	a5,80005428 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000533a:	6605                	lui	a2,0x1
    8000533c:	4581                	li	a1,0
    8000533e:	ffffb097          	auipc	ra,0xffffb
    80005342:	e3a080e7          	jalr	-454(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005346:	00015497          	auipc	s1,0x15
    8000534a:	82a48493          	addi	s1,s1,-2006 # 80019b70 <disk>
    8000534e:	6605                	lui	a2,0x1
    80005350:	4581                	li	a1,0
    80005352:	6488                	ld	a0,8(s1)
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e24080e7          	jalr	-476(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000535c:	6605                	lui	a2,0x1
    8000535e:	4581                	li	a1,0
    80005360:	6888                	ld	a0,16(s1)
    80005362:	ffffb097          	auipc	ra,0xffffb
    80005366:	e16080e7          	jalr	-490(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000536a:	100017b7          	lui	a5,0x10001
    8000536e:	4721                	li	a4,8
    80005370:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005372:	4098                	lw	a4,0(s1)
    80005374:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005378:	40d8                	lw	a4,4(s1)
    8000537a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000537e:	6498                	ld	a4,8(s1)
    80005380:	0007069b          	sext.w	a3,a4
    80005384:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005388:	9701                	srai	a4,a4,0x20
    8000538a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000538e:	6898                	ld	a4,16(s1)
    80005390:	0007069b          	sext.w	a3,a4
    80005394:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005398:	9701                	srai	a4,a4,0x20
    8000539a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000539e:	4685                	li	a3,1
    800053a0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800053a2:	4705                	li	a4,1
    800053a4:	00d48c23          	sb	a3,24(s1)
    800053a8:	00e48ca3          	sb	a4,25(s1)
    800053ac:	00e48d23          	sb	a4,26(s1)
    800053b0:	00e48da3          	sb	a4,27(s1)
    800053b4:	00e48e23          	sb	a4,28(s1)
    800053b8:	00e48ea3          	sb	a4,29(s1)
    800053bc:	00e48f23          	sb	a4,30(s1)
    800053c0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053c4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c8:	0727a823          	sw	s2,112(a5)
}
    800053cc:	60e2                	ld	ra,24(sp)
    800053ce:	6442                	ld	s0,16(sp)
    800053d0:	64a2                	ld	s1,8(sp)
    800053d2:	6902                	ld	s2,0(sp)
    800053d4:	6105                	addi	sp,sp,32
    800053d6:	8082                	ret
    panic("could not find virtio disk");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	4d850513          	addi	a0,a0,1240 # 800088b0 <syscall_list+0x320>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	8c2080e7          	jalr	-1854(ra) # 80005ca2 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	4e850513          	addi	a0,a0,1256 # 800088d0 <syscall_list+0x340>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	8b2080e7          	jalr	-1870(ra) # 80005ca2 <panic>
    panic("virtio disk should not be ready");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	4f850513          	addi	a0,a0,1272 # 800088f0 <syscall_list+0x360>
    80005400:	00001097          	auipc	ra,0x1
    80005404:	8a2080e7          	jalr	-1886(ra) # 80005ca2 <panic>
    panic("virtio disk has no queue 0");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	50850513          	addi	a0,a0,1288 # 80008910 <syscall_list+0x380>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	892080e7          	jalr	-1902(ra) # 80005ca2 <panic>
    panic("virtio disk max queue too short");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	51850513          	addi	a0,a0,1304 # 80008930 <syscall_list+0x3a0>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	882080e7          	jalr	-1918(ra) # 80005ca2 <panic>
    panic("virtio disk kalloc");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	52850513          	addi	a0,a0,1320 # 80008950 <syscall_list+0x3c0>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	872080e7          	jalr	-1934(ra) # 80005ca2 <panic>

0000000080005438 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005438:	7159                	addi	sp,sp,-112
    8000543a:	f486                	sd	ra,104(sp)
    8000543c:	f0a2                	sd	s0,96(sp)
    8000543e:	eca6                	sd	s1,88(sp)
    80005440:	e8ca                	sd	s2,80(sp)
    80005442:	e4ce                	sd	s3,72(sp)
    80005444:	e0d2                	sd	s4,64(sp)
    80005446:	fc56                	sd	s5,56(sp)
    80005448:	f85a                	sd	s6,48(sp)
    8000544a:	f45e                	sd	s7,40(sp)
    8000544c:	f062                	sd	s8,32(sp)
    8000544e:	ec66                	sd	s9,24(sp)
    80005450:	e86a                	sd	s10,16(sp)
    80005452:	1880                	addi	s0,sp,112
    80005454:	892a                	mv	s2,a0
    80005456:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005458:	00c52c83          	lw	s9,12(a0)
    8000545c:	001c9c9b          	slliw	s9,s9,0x1
    80005460:	1c82                	slli	s9,s9,0x20
    80005462:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005466:	00015517          	auipc	a0,0x15
    8000546a:	83250513          	addi	a0,a0,-1998 # 80019c98 <disk+0x128>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	d7e080e7          	jalr	-642(ra) # 800061ec <acquire>
  for(int i = 0; i < 3; i++){
    80005476:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005478:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000547a:	00014b17          	auipc	s6,0x14
    8000547e:	6f6b0b13          	addi	s6,s6,1782 # 80019b70 <disk>
  for(int i = 0; i < 3; i++){
    80005482:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005484:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005486:	00015c17          	auipc	s8,0x15
    8000548a:	812c0c13          	addi	s8,s8,-2030 # 80019c98 <disk+0x128>
    8000548e:	a8b5                	j	8000550a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005490:	00fb06b3          	add	a3,s6,a5
    80005494:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005498:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000549a:	0207c563          	bltz	a5,800054c4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000549e:	2485                	addiw	s1,s1,1
    800054a0:	0711                	addi	a4,a4,4
    800054a2:	1f548a63          	beq	s1,s5,80005696 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800054a6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054a8:	00014697          	auipc	a3,0x14
    800054ac:	6c868693          	addi	a3,a3,1736 # 80019b70 <disk>
    800054b0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054b2:	0186c583          	lbu	a1,24(a3)
    800054b6:	fde9                	bnez	a1,80005490 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800054b8:	2785                	addiw	a5,a5,1
    800054ba:	0685                	addi	a3,a3,1
    800054bc:	ff779be3          	bne	a5,s7,800054b2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800054c0:	57fd                	li	a5,-1
    800054c2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054c4:	02905a63          	blez	s1,800054f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054c8:	f9042503          	lw	a0,-112(s0)
    800054cc:	00000097          	auipc	ra,0x0
    800054d0:	cfa080e7          	jalr	-774(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    800054d4:	4785                	li	a5,1
    800054d6:	0297d163          	bge	a5,s1,800054f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054da:	f9442503          	lw	a0,-108(s0)
    800054de:	00000097          	auipc	ra,0x0
    800054e2:	ce8080e7          	jalr	-792(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    800054e6:	4789                	li	a5,2
    800054e8:	0097d863          	bge	a5,s1,800054f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054ec:	f9842503          	lw	a0,-104(s0)
    800054f0:	00000097          	auipc	ra,0x0
    800054f4:	cd6080e7          	jalr	-810(ra) # 800051c6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054f8:	85e2                	mv	a1,s8
    800054fa:	00014517          	auipc	a0,0x14
    800054fe:	68e50513          	addi	a0,a0,1678 # 80019b88 <disk+0x18>
    80005502:	ffffc097          	auipc	ra,0xffffc
    80005506:	05e080e7          	jalr	94(ra) # 80001560 <sleep>
  for(int i = 0; i < 3; i++){
    8000550a:	f9040713          	addi	a4,s0,-112
    8000550e:	84ce                	mv	s1,s3
    80005510:	bf59                	j	800054a6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005512:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005516:	00479693          	slli	a3,a5,0x4
    8000551a:	00014797          	auipc	a5,0x14
    8000551e:	65678793          	addi	a5,a5,1622 # 80019b70 <disk>
    80005522:	97b6                	add	a5,a5,a3
    80005524:	4685                	li	a3,1
    80005526:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005528:	00014597          	auipc	a1,0x14
    8000552c:	64858593          	addi	a1,a1,1608 # 80019b70 <disk>
    80005530:	00a60793          	addi	a5,a2,10
    80005534:	0792                	slli	a5,a5,0x4
    80005536:	97ae                	add	a5,a5,a1
    80005538:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000553c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005540:	f6070693          	addi	a3,a4,-160
    80005544:	619c                	ld	a5,0(a1)
    80005546:	97b6                	add	a5,a5,a3
    80005548:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000554a:	6188                	ld	a0,0(a1)
    8000554c:	96aa                	add	a3,a3,a0
    8000554e:	47c1                	li	a5,16
    80005550:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005552:	4785                	li	a5,1
    80005554:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005558:	f9442783          	lw	a5,-108(s0)
    8000555c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005560:	0792                	slli	a5,a5,0x4
    80005562:	953e                	add	a0,a0,a5
    80005564:	05890693          	addi	a3,s2,88
    80005568:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000556a:	6188                	ld	a0,0(a1)
    8000556c:	97aa                	add	a5,a5,a0
    8000556e:	40000693          	li	a3,1024
    80005572:	c794                	sw	a3,8(a5)
  if(write)
    80005574:	100d0d63          	beqz	s10,8000568e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005578:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000557c:	00c7d683          	lhu	a3,12(a5)
    80005580:	0016e693          	ori	a3,a3,1
    80005584:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005588:	f9842583          	lw	a1,-104(s0)
    8000558c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005590:	00014697          	auipc	a3,0x14
    80005594:	5e068693          	addi	a3,a3,1504 # 80019b70 <disk>
    80005598:	00260793          	addi	a5,a2,2
    8000559c:	0792                	slli	a5,a5,0x4
    8000559e:	97b6                	add	a5,a5,a3
    800055a0:	587d                	li	a6,-1
    800055a2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055a6:	0592                	slli	a1,a1,0x4
    800055a8:	952e                	add	a0,a0,a1
    800055aa:	f9070713          	addi	a4,a4,-112
    800055ae:	9736                	add	a4,a4,a3
    800055b0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800055b2:	6298                	ld	a4,0(a3)
    800055b4:	972e                	add	a4,a4,a1
    800055b6:	4585                	li	a1,1
    800055b8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055ba:	4509                	li	a0,2
    800055bc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800055c0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055c4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800055c8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055cc:	6698                	ld	a4,8(a3)
    800055ce:	00275783          	lhu	a5,2(a4)
    800055d2:	8b9d                	andi	a5,a5,7
    800055d4:	0786                	slli	a5,a5,0x1
    800055d6:	97ba                	add	a5,a5,a4
    800055d8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800055dc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055e0:	6698                	ld	a4,8(a3)
    800055e2:	00275783          	lhu	a5,2(a4)
    800055e6:	2785                	addiw	a5,a5,1
    800055e8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055ec:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055f0:	100017b7          	lui	a5,0x10001
    800055f4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055f8:	00492703          	lw	a4,4(s2)
    800055fc:	4785                	li	a5,1
    800055fe:	02f71163          	bne	a4,a5,80005620 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005602:	00014997          	auipc	s3,0x14
    80005606:	69698993          	addi	s3,s3,1686 # 80019c98 <disk+0x128>
  while(b->disk == 1) {
    8000560a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000560c:	85ce                	mv	a1,s3
    8000560e:	854a                	mv	a0,s2
    80005610:	ffffc097          	auipc	ra,0xffffc
    80005614:	f50080e7          	jalr	-176(ra) # 80001560 <sleep>
  while(b->disk == 1) {
    80005618:	00492783          	lw	a5,4(s2)
    8000561c:	fe9788e3          	beq	a5,s1,8000560c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005620:	f9042903          	lw	s2,-112(s0)
    80005624:	00290793          	addi	a5,s2,2
    80005628:	00479713          	slli	a4,a5,0x4
    8000562c:	00014797          	auipc	a5,0x14
    80005630:	54478793          	addi	a5,a5,1348 # 80019b70 <disk>
    80005634:	97ba                	add	a5,a5,a4
    80005636:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000563a:	00014997          	auipc	s3,0x14
    8000563e:	53698993          	addi	s3,s3,1334 # 80019b70 <disk>
    80005642:	00491713          	slli	a4,s2,0x4
    80005646:	0009b783          	ld	a5,0(s3)
    8000564a:	97ba                	add	a5,a5,a4
    8000564c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005650:	854a                	mv	a0,s2
    80005652:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005656:	00000097          	auipc	ra,0x0
    8000565a:	b70080e7          	jalr	-1168(ra) # 800051c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000565e:	8885                	andi	s1,s1,1
    80005660:	f0ed                	bnez	s1,80005642 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005662:	00014517          	auipc	a0,0x14
    80005666:	63650513          	addi	a0,a0,1590 # 80019c98 <disk+0x128>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	c36080e7          	jalr	-970(ra) # 800062a0 <release>
}
    80005672:	70a6                	ld	ra,104(sp)
    80005674:	7406                	ld	s0,96(sp)
    80005676:	64e6                	ld	s1,88(sp)
    80005678:	6946                	ld	s2,80(sp)
    8000567a:	69a6                	ld	s3,72(sp)
    8000567c:	6a06                	ld	s4,64(sp)
    8000567e:	7ae2                	ld	s5,56(sp)
    80005680:	7b42                	ld	s6,48(sp)
    80005682:	7ba2                	ld	s7,40(sp)
    80005684:	7c02                	ld	s8,32(sp)
    80005686:	6ce2                	ld	s9,24(sp)
    80005688:	6d42                	ld	s10,16(sp)
    8000568a:	6165                	addi	sp,sp,112
    8000568c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000568e:	4689                	li	a3,2
    80005690:	00d79623          	sh	a3,12(a5)
    80005694:	b5e5                	j	8000557c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005696:	f9042603          	lw	a2,-112(s0)
    8000569a:	00a60713          	addi	a4,a2,10
    8000569e:	0712                	slli	a4,a4,0x4
    800056a0:	00014517          	auipc	a0,0x14
    800056a4:	4d850513          	addi	a0,a0,1240 # 80019b78 <disk+0x8>
    800056a8:	953a                	add	a0,a0,a4
  if(write)
    800056aa:	e60d14e3          	bnez	s10,80005512 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056ae:	00a60793          	addi	a5,a2,10
    800056b2:	00479693          	slli	a3,a5,0x4
    800056b6:	00014797          	auipc	a5,0x14
    800056ba:	4ba78793          	addi	a5,a5,1210 # 80019b70 <disk>
    800056be:	97b6                	add	a5,a5,a3
    800056c0:	0007a423          	sw	zero,8(a5)
    800056c4:	b595                	j	80005528 <virtio_disk_rw+0xf0>

00000000800056c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056c6:	1101                	addi	sp,sp,-32
    800056c8:	ec06                	sd	ra,24(sp)
    800056ca:	e822                	sd	s0,16(sp)
    800056cc:	e426                	sd	s1,8(sp)
    800056ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056d0:	00014497          	auipc	s1,0x14
    800056d4:	4a048493          	addi	s1,s1,1184 # 80019b70 <disk>
    800056d8:	00014517          	auipc	a0,0x14
    800056dc:	5c050513          	addi	a0,a0,1472 # 80019c98 <disk+0x128>
    800056e0:	00001097          	auipc	ra,0x1
    800056e4:	b0c080e7          	jalr	-1268(ra) # 800061ec <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056e8:	10001737          	lui	a4,0x10001
    800056ec:	533c                	lw	a5,96(a4)
    800056ee:	8b8d                	andi	a5,a5,3
    800056f0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056f2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056f6:	689c                	ld	a5,16(s1)
    800056f8:	0204d703          	lhu	a4,32(s1)
    800056fc:	0027d783          	lhu	a5,2(a5)
    80005700:	04f70863          	beq	a4,a5,80005750 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005704:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005708:	6898                	ld	a4,16(s1)
    8000570a:	0204d783          	lhu	a5,32(s1)
    8000570e:	8b9d                	andi	a5,a5,7
    80005710:	078e                	slli	a5,a5,0x3
    80005712:	97ba                	add	a5,a5,a4
    80005714:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005716:	00278713          	addi	a4,a5,2
    8000571a:	0712                	slli	a4,a4,0x4
    8000571c:	9726                	add	a4,a4,s1
    8000571e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005722:	e721                	bnez	a4,8000576a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005724:	0789                	addi	a5,a5,2
    80005726:	0792                	slli	a5,a5,0x4
    80005728:	97a6                	add	a5,a5,s1
    8000572a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000572c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005730:	ffffc097          	auipc	ra,0xffffc
    80005734:	e94080e7          	jalr	-364(ra) # 800015c4 <wakeup>

    disk.used_idx += 1;
    80005738:	0204d783          	lhu	a5,32(s1)
    8000573c:	2785                	addiw	a5,a5,1
    8000573e:	17c2                	slli	a5,a5,0x30
    80005740:	93c1                	srli	a5,a5,0x30
    80005742:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005746:	6898                	ld	a4,16(s1)
    80005748:	00275703          	lhu	a4,2(a4)
    8000574c:	faf71ce3          	bne	a4,a5,80005704 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005750:	00014517          	auipc	a0,0x14
    80005754:	54850513          	addi	a0,a0,1352 # 80019c98 <disk+0x128>
    80005758:	00001097          	auipc	ra,0x1
    8000575c:	b48080e7          	jalr	-1208(ra) # 800062a0 <release>
}
    80005760:	60e2                	ld	ra,24(sp)
    80005762:	6442                	ld	s0,16(sp)
    80005764:	64a2                	ld	s1,8(sp)
    80005766:	6105                	addi	sp,sp,32
    80005768:	8082                	ret
      panic("virtio_disk_intr status");
    8000576a:	00003517          	auipc	a0,0x3
    8000576e:	1fe50513          	addi	a0,a0,510 # 80008968 <syscall_list+0x3d8>
    80005772:	00000097          	auipc	ra,0x0
    80005776:	530080e7          	jalr	1328(ra) # 80005ca2 <panic>

000000008000577a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000577a:	1141                	addi	sp,sp,-16
    8000577c:	e422                	sd	s0,8(sp)
    8000577e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005780:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005784:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005788:	0037979b          	slliw	a5,a5,0x3
    8000578c:	02004737          	lui	a4,0x2004
    80005790:	97ba                	add	a5,a5,a4
    80005792:	0200c737          	lui	a4,0x200c
    80005796:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000579a:	000f4637          	lui	a2,0xf4
    8000579e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057a2:	95b2                	add	a1,a1,a2
    800057a4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057a6:	00269713          	slli	a4,a3,0x2
    800057aa:	9736                	add	a4,a4,a3
    800057ac:	00371693          	slli	a3,a4,0x3
    800057b0:	00014717          	auipc	a4,0x14
    800057b4:	50070713          	addi	a4,a4,1280 # 80019cb0 <timer_scratch>
    800057b8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057ba:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057bc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057be:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057c2:	00000797          	auipc	a5,0x0
    800057c6:	93e78793          	addi	a5,a5,-1730 # 80005100 <timervec>
    800057ca:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ce:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057d2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057da:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057de:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057e2:	30479073          	csrw	mie,a5
}
    800057e6:	6422                	ld	s0,8(sp)
    800057e8:	0141                	addi	sp,sp,16
    800057ea:	8082                	ret

00000000800057ec <start>:
{
    800057ec:	1141                	addi	sp,sp,-16
    800057ee:	e406                	sd	ra,8(sp)
    800057f0:	e022                	sd	s0,0(sp)
    800057f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057f4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057f8:	7779                	lui	a4,0xffffe
    800057fa:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc90f>
    800057fe:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005800:	6705                	lui	a4,0x1
    80005802:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005806:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005808:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000580c:	ffffb797          	auipc	a5,0xffffb
    80005810:	b1a78793          	addi	a5,a5,-1254 # 80000326 <main>
    80005814:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005818:	4781                	li	a5,0
    8000581a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000581e:	67c1                	lui	a5,0x10
    80005820:	17fd                	addi	a5,a5,-1
    80005822:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005826:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000582a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000582e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005832:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005836:	57fd                	li	a5,-1
    80005838:	83a9                	srli	a5,a5,0xa
    8000583a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000583e:	47bd                	li	a5,15
    80005840:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005844:	00000097          	auipc	ra,0x0
    80005848:	f36080e7          	jalr	-202(ra) # 8000577a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000584c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005850:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005852:	823e                	mv	tp,a5
  asm volatile("mret");
    80005854:	30200073          	mret
}
    80005858:	60a2                	ld	ra,8(sp)
    8000585a:	6402                	ld	s0,0(sp)
    8000585c:	0141                	addi	sp,sp,16
    8000585e:	8082                	ret

0000000080005860 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005860:	715d                	addi	sp,sp,-80
    80005862:	e486                	sd	ra,72(sp)
    80005864:	e0a2                	sd	s0,64(sp)
    80005866:	fc26                	sd	s1,56(sp)
    80005868:	f84a                	sd	s2,48(sp)
    8000586a:	f44e                	sd	s3,40(sp)
    8000586c:	f052                	sd	s4,32(sp)
    8000586e:	ec56                	sd	s5,24(sp)
    80005870:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005872:	04c05663          	blez	a2,800058be <consolewrite+0x5e>
    80005876:	8a2a                	mv	s4,a0
    80005878:	84ae                	mv	s1,a1
    8000587a:	89b2                	mv	s3,a2
    8000587c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000587e:	5afd                	li	s5,-1
    80005880:	4685                	li	a3,1
    80005882:	8626                	mv	a2,s1
    80005884:	85d2                	mv	a1,s4
    80005886:	fbf40513          	addi	a0,s0,-65
    8000588a:	ffffc097          	auipc	ra,0xffffc
    8000588e:	134080e7          	jalr	308(ra) # 800019be <either_copyin>
    80005892:	01550c63          	beq	a0,s5,800058aa <consolewrite+0x4a>
      break;
    uartputc(c);
    80005896:	fbf44503          	lbu	a0,-65(s0)
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	794080e7          	jalr	1940(ra) # 8000602e <uartputc>
  for(i = 0; i < n; i++){
    800058a2:	2905                	addiw	s2,s2,1
    800058a4:	0485                	addi	s1,s1,1
    800058a6:	fd299de3          	bne	s3,s2,80005880 <consolewrite+0x20>
  }

  return i;
}
    800058aa:	854a                	mv	a0,s2
    800058ac:	60a6                	ld	ra,72(sp)
    800058ae:	6406                	ld	s0,64(sp)
    800058b0:	74e2                	ld	s1,56(sp)
    800058b2:	7942                	ld	s2,48(sp)
    800058b4:	79a2                	ld	s3,40(sp)
    800058b6:	7a02                	ld	s4,32(sp)
    800058b8:	6ae2                	ld	s5,24(sp)
    800058ba:	6161                	addi	sp,sp,80
    800058bc:	8082                	ret
  for(i = 0; i < n; i++){
    800058be:	4901                	li	s2,0
    800058c0:	b7ed                	j	800058aa <consolewrite+0x4a>

00000000800058c2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058c2:	7119                	addi	sp,sp,-128
    800058c4:	fc86                	sd	ra,120(sp)
    800058c6:	f8a2                	sd	s0,112(sp)
    800058c8:	f4a6                	sd	s1,104(sp)
    800058ca:	f0ca                	sd	s2,96(sp)
    800058cc:	ecce                	sd	s3,88(sp)
    800058ce:	e8d2                	sd	s4,80(sp)
    800058d0:	e4d6                	sd	s5,72(sp)
    800058d2:	e0da                	sd	s6,64(sp)
    800058d4:	fc5e                	sd	s7,56(sp)
    800058d6:	f862                	sd	s8,48(sp)
    800058d8:	f466                	sd	s9,40(sp)
    800058da:	f06a                	sd	s10,32(sp)
    800058dc:	ec6e                	sd	s11,24(sp)
    800058de:	0100                	addi	s0,sp,128
    800058e0:	8b2a                	mv	s6,a0
    800058e2:	8aae                	mv	s5,a1
    800058e4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058e6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058ea:	0001c517          	auipc	a0,0x1c
    800058ee:	50650513          	addi	a0,a0,1286 # 80021df0 <cons>
    800058f2:	00001097          	auipc	ra,0x1
    800058f6:	8fa080e7          	jalr	-1798(ra) # 800061ec <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058fa:	0001c497          	auipc	s1,0x1c
    800058fe:	4f648493          	addi	s1,s1,1270 # 80021df0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005902:	89a6                	mv	s3,s1
    80005904:	0001c917          	auipc	s2,0x1c
    80005908:	58490913          	addi	s2,s2,1412 # 80021e88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000590c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005910:	4da9                	li	s11,10
  while(n > 0){
    80005912:	07405b63          	blez	s4,80005988 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005916:	0984a783          	lw	a5,152(s1)
    8000591a:	09c4a703          	lw	a4,156(s1)
    8000591e:	02f71763          	bne	a4,a5,8000594c <consoleread+0x8a>
      if(killed(myproc())){
    80005922:	ffffb097          	auipc	ra,0xffffb
    80005926:	58e080e7          	jalr	1422(ra) # 80000eb0 <myproc>
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	ede080e7          	jalr	-290(ra) # 80001808 <killed>
    80005932:	e535                	bnez	a0,8000599e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005934:	85ce                	mv	a1,s3
    80005936:	854a                	mv	a0,s2
    80005938:	ffffc097          	auipc	ra,0xffffc
    8000593c:	c28080e7          	jalr	-984(ra) # 80001560 <sleep>
    while(cons.r == cons.w){
    80005940:	0984a783          	lw	a5,152(s1)
    80005944:	09c4a703          	lw	a4,156(s1)
    80005948:	fcf70de3          	beq	a4,a5,80005922 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000594c:	0017871b          	addiw	a4,a5,1
    80005950:	08e4ac23          	sw	a4,152(s1)
    80005954:	07f7f713          	andi	a4,a5,127
    80005958:	9726                	add	a4,a4,s1
    8000595a:	01874703          	lbu	a4,24(a4)
    8000595e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005962:	079c0663          	beq	s8,s9,800059ce <consoleread+0x10c>
    cbuf = c;
    80005966:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000596a:	4685                	li	a3,1
    8000596c:	f8f40613          	addi	a2,s0,-113
    80005970:	85d6                	mv	a1,s5
    80005972:	855a                	mv	a0,s6
    80005974:	ffffc097          	auipc	ra,0xffffc
    80005978:	ff4080e7          	jalr	-12(ra) # 80001968 <either_copyout>
    8000597c:	01a50663          	beq	a0,s10,80005988 <consoleread+0xc6>
    dst++;
    80005980:	0a85                	addi	s5,s5,1
    --n;
    80005982:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005984:	f9bc17e3          	bne	s8,s11,80005912 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005988:	0001c517          	auipc	a0,0x1c
    8000598c:	46850513          	addi	a0,a0,1128 # 80021df0 <cons>
    80005990:	00001097          	auipc	ra,0x1
    80005994:	910080e7          	jalr	-1776(ra) # 800062a0 <release>

  return target - n;
    80005998:	414b853b          	subw	a0,s7,s4
    8000599c:	a811                	j	800059b0 <consoleread+0xee>
        release(&cons.lock);
    8000599e:	0001c517          	auipc	a0,0x1c
    800059a2:	45250513          	addi	a0,a0,1106 # 80021df0 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	8fa080e7          	jalr	-1798(ra) # 800062a0 <release>
        return -1;
    800059ae:	557d                	li	a0,-1
}
    800059b0:	70e6                	ld	ra,120(sp)
    800059b2:	7446                	ld	s0,112(sp)
    800059b4:	74a6                	ld	s1,104(sp)
    800059b6:	7906                	ld	s2,96(sp)
    800059b8:	69e6                	ld	s3,88(sp)
    800059ba:	6a46                	ld	s4,80(sp)
    800059bc:	6aa6                	ld	s5,72(sp)
    800059be:	6b06                	ld	s6,64(sp)
    800059c0:	7be2                	ld	s7,56(sp)
    800059c2:	7c42                	ld	s8,48(sp)
    800059c4:	7ca2                	ld	s9,40(sp)
    800059c6:	7d02                	ld	s10,32(sp)
    800059c8:	6de2                	ld	s11,24(sp)
    800059ca:	6109                	addi	sp,sp,128
    800059cc:	8082                	ret
      if(n < target){
    800059ce:	000a071b          	sext.w	a4,s4
    800059d2:	fb777be3          	bgeu	a4,s7,80005988 <consoleread+0xc6>
        cons.r--;
    800059d6:	0001c717          	auipc	a4,0x1c
    800059da:	4af72923          	sw	a5,1202(a4) # 80021e88 <cons+0x98>
    800059de:	b76d                	j	80005988 <consoleread+0xc6>

00000000800059e0 <consputc>:
{
    800059e0:	1141                	addi	sp,sp,-16
    800059e2:	e406                	sd	ra,8(sp)
    800059e4:	e022                	sd	s0,0(sp)
    800059e6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059e8:	10000793          	li	a5,256
    800059ec:	00f50a63          	beq	a0,a5,80005a00 <consputc+0x20>
    uartputc_sync(c);
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	564080e7          	jalr	1380(ra) # 80005f54 <uartputc_sync>
}
    800059f8:	60a2                	ld	ra,8(sp)
    800059fa:	6402                	ld	s0,0(sp)
    800059fc:	0141                	addi	sp,sp,16
    800059fe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a00:	4521                	li	a0,8
    80005a02:	00000097          	auipc	ra,0x0
    80005a06:	552080e7          	jalr	1362(ra) # 80005f54 <uartputc_sync>
    80005a0a:	02000513          	li	a0,32
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	546080e7          	jalr	1350(ra) # 80005f54 <uartputc_sync>
    80005a16:	4521                	li	a0,8
    80005a18:	00000097          	auipc	ra,0x0
    80005a1c:	53c080e7          	jalr	1340(ra) # 80005f54 <uartputc_sync>
    80005a20:	bfe1                	j	800059f8 <consputc+0x18>

0000000080005a22 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a22:	1101                	addi	sp,sp,-32
    80005a24:	ec06                	sd	ra,24(sp)
    80005a26:	e822                	sd	s0,16(sp)
    80005a28:	e426                	sd	s1,8(sp)
    80005a2a:	e04a                	sd	s2,0(sp)
    80005a2c:	1000                	addi	s0,sp,32
    80005a2e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a30:	0001c517          	auipc	a0,0x1c
    80005a34:	3c050513          	addi	a0,a0,960 # 80021df0 <cons>
    80005a38:	00000097          	auipc	ra,0x0
    80005a3c:	7b4080e7          	jalr	1972(ra) # 800061ec <acquire>

  switch(c){
    80005a40:	47d5                	li	a5,21
    80005a42:	0af48663          	beq	s1,a5,80005aee <consoleintr+0xcc>
    80005a46:	0297ca63          	blt	a5,s1,80005a7a <consoleintr+0x58>
    80005a4a:	47a1                	li	a5,8
    80005a4c:	0ef48763          	beq	s1,a5,80005b3a <consoleintr+0x118>
    80005a50:	47c1                	li	a5,16
    80005a52:	10f49a63          	bne	s1,a5,80005b66 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	fbe080e7          	jalr	-66(ra) # 80001a14 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a5e:	0001c517          	auipc	a0,0x1c
    80005a62:	39250513          	addi	a0,a0,914 # 80021df0 <cons>
    80005a66:	00001097          	auipc	ra,0x1
    80005a6a:	83a080e7          	jalr	-1990(ra) # 800062a0 <release>
}
    80005a6e:	60e2                	ld	ra,24(sp)
    80005a70:	6442                	ld	s0,16(sp)
    80005a72:	64a2                	ld	s1,8(sp)
    80005a74:	6902                	ld	s2,0(sp)
    80005a76:	6105                	addi	sp,sp,32
    80005a78:	8082                	ret
  switch(c){
    80005a7a:	07f00793          	li	a5,127
    80005a7e:	0af48e63          	beq	s1,a5,80005b3a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a82:	0001c717          	auipc	a4,0x1c
    80005a86:	36e70713          	addi	a4,a4,878 # 80021df0 <cons>
    80005a8a:	0a072783          	lw	a5,160(a4)
    80005a8e:	09872703          	lw	a4,152(a4)
    80005a92:	9f99                	subw	a5,a5,a4
    80005a94:	07f00713          	li	a4,127
    80005a98:	fcf763e3          	bltu	a4,a5,80005a5e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a9c:	47b5                	li	a5,13
    80005a9e:	0cf48763          	beq	s1,a5,80005b6c <consoleintr+0x14a>
      consputc(c);
    80005aa2:	8526                	mv	a0,s1
    80005aa4:	00000097          	auipc	ra,0x0
    80005aa8:	f3c080e7          	jalr	-196(ra) # 800059e0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005aac:	0001c797          	auipc	a5,0x1c
    80005ab0:	34478793          	addi	a5,a5,836 # 80021df0 <cons>
    80005ab4:	0a07a683          	lw	a3,160(a5)
    80005ab8:	0016871b          	addiw	a4,a3,1
    80005abc:	0007061b          	sext.w	a2,a4
    80005ac0:	0ae7a023          	sw	a4,160(a5)
    80005ac4:	07f6f693          	andi	a3,a3,127
    80005ac8:	97b6                	add	a5,a5,a3
    80005aca:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ace:	47a9                	li	a5,10
    80005ad0:	0cf48563          	beq	s1,a5,80005b9a <consoleintr+0x178>
    80005ad4:	4791                	li	a5,4
    80005ad6:	0cf48263          	beq	s1,a5,80005b9a <consoleintr+0x178>
    80005ada:	0001c797          	auipc	a5,0x1c
    80005ade:	3ae7a783          	lw	a5,942(a5) # 80021e88 <cons+0x98>
    80005ae2:	9f1d                	subw	a4,a4,a5
    80005ae4:	08000793          	li	a5,128
    80005ae8:	f6f71be3          	bne	a4,a5,80005a5e <consoleintr+0x3c>
    80005aec:	a07d                	j	80005b9a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aee:	0001c717          	auipc	a4,0x1c
    80005af2:	30270713          	addi	a4,a4,770 # 80021df0 <cons>
    80005af6:	0a072783          	lw	a5,160(a4)
    80005afa:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005afe:	0001c497          	auipc	s1,0x1c
    80005b02:	2f248493          	addi	s1,s1,754 # 80021df0 <cons>
    while(cons.e != cons.w &&
    80005b06:	4929                	li	s2,10
    80005b08:	f4f70be3          	beq	a4,a5,80005a5e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b0c:	37fd                	addiw	a5,a5,-1
    80005b0e:	07f7f713          	andi	a4,a5,127
    80005b12:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b14:	01874703          	lbu	a4,24(a4)
    80005b18:	f52703e3          	beq	a4,s2,80005a5e <consoleintr+0x3c>
      cons.e--;
    80005b1c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b20:	10000513          	li	a0,256
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	ebc080e7          	jalr	-324(ra) # 800059e0 <consputc>
    while(cons.e != cons.w &&
    80005b2c:	0a04a783          	lw	a5,160(s1)
    80005b30:	09c4a703          	lw	a4,156(s1)
    80005b34:	fcf71ce3          	bne	a4,a5,80005b0c <consoleintr+0xea>
    80005b38:	b71d                	j	80005a5e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b3a:	0001c717          	auipc	a4,0x1c
    80005b3e:	2b670713          	addi	a4,a4,694 # 80021df0 <cons>
    80005b42:	0a072783          	lw	a5,160(a4)
    80005b46:	09c72703          	lw	a4,156(a4)
    80005b4a:	f0f70ae3          	beq	a4,a5,80005a5e <consoleintr+0x3c>
      cons.e--;
    80005b4e:	37fd                	addiw	a5,a5,-1
    80005b50:	0001c717          	auipc	a4,0x1c
    80005b54:	34f72023          	sw	a5,832(a4) # 80021e90 <cons+0xa0>
      consputc(BACKSPACE);
    80005b58:	10000513          	li	a0,256
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	e84080e7          	jalr	-380(ra) # 800059e0 <consputc>
    80005b64:	bded                	j	80005a5e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b66:	ee048ce3          	beqz	s1,80005a5e <consoleintr+0x3c>
    80005b6a:	bf21                	j	80005a82 <consoleintr+0x60>
      consputc(c);
    80005b6c:	4529                	li	a0,10
    80005b6e:	00000097          	auipc	ra,0x0
    80005b72:	e72080e7          	jalr	-398(ra) # 800059e0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b76:	0001c797          	auipc	a5,0x1c
    80005b7a:	27a78793          	addi	a5,a5,634 # 80021df0 <cons>
    80005b7e:	0a07a703          	lw	a4,160(a5)
    80005b82:	0017069b          	addiw	a3,a4,1
    80005b86:	0006861b          	sext.w	a2,a3
    80005b8a:	0ad7a023          	sw	a3,160(a5)
    80005b8e:	07f77713          	andi	a4,a4,127
    80005b92:	97ba                	add	a5,a5,a4
    80005b94:	4729                	li	a4,10
    80005b96:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b9a:	0001c797          	auipc	a5,0x1c
    80005b9e:	2ec7a923          	sw	a2,754(a5) # 80021e8c <cons+0x9c>
        wakeup(&cons.r);
    80005ba2:	0001c517          	auipc	a0,0x1c
    80005ba6:	2e650513          	addi	a0,a0,742 # 80021e88 <cons+0x98>
    80005baa:	ffffc097          	auipc	ra,0xffffc
    80005bae:	a1a080e7          	jalr	-1510(ra) # 800015c4 <wakeup>
    80005bb2:	b575                	j	80005a5e <consoleintr+0x3c>

0000000080005bb4 <consoleinit>:

void
consoleinit(void)
{
    80005bb4:	1141                	addi	sp,sp,-16
    80005bb6:	e406                	sd	ra,8(sp)
    80005bb8:	e022                	sd	s0,0(sp)
    80005bba:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bbc:	00003597          	auipc	a1,0x3
    80005bc0:	dc458593          	addi	a1,a1,-572 # 80008980 <syscall_list+0x3f0>
    80005bc4:	0001c517          	auipc	a0,0x1c
    80005bc8:	22c50513          	addi	a0,a0,556 # 80021df0 <cons>
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	590080e7          	jalr	1424(ra) # 8000615c <initlock>

  uartinit();
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	330080e7          	jalr	816(ra) # 80005f04 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bdc:	00013797          	auipc	a5,0x13
    80005be0:	f3c78793          	addi	a5,a5,-196 # 80018b18 <devsw>
    80005be4:	00000717          	auipc	a4,0x0
    80005be8:	cde70713          	addi	a4,a4,-802 # 800058c2 <consoleread>
    80005bec:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bee:	00000717          	auipc	a4,0x0
    80005bf2:	c7270713          	addi	a4,a4,-910 # 80005860 <consolewrite>
    80005bf6:	ef98                	sd	a4,24(a5)
}
    80005bf8:	60a2                	ld	ra,8(sp)
    80005bfa:	6402                	ld	s0,0(sp)
    80005bfc:	0141                	addi	sp,sp,16
    80005bfe:	8082                	ret

0000000080005c00 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c00:	7179                	addi	sp,sp,-48
    80005c02:	f406                	sd	ra,40(sp)
    80005c04:	f022                	sd	s0,32(sp)
    80005c06:	ec26                	sd	s1,24(sp)
    80005c08:	e84a                	sd	s2,16(sp)
    80005c0a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c0c:	c219                	beqz	a2,80005c12 <printint+0x12>
    80005c0e:	08054663          	bltz	a0,80005c9a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c12:	2501                	sext.w	a0,a0
    80005c14:	4881                	li	a7,0
    80005c16:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c1a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c1c:	2581                	sext.w	a1,a1
    80005c1e:	00003617          	auipc	a2,0x3
    80005c22:	d9260613          	addi	a2,a2,-622 # 800089b0 <digits>
    80005c26:	883a                	mv	a6,a4
    80005c28:	2705                	addiw	a4,a4,1
    80005c2a:	02b577bb          	remuw	a5,a0,a1
    80005c2e:	1782                	slli	a5,a5,0x20
    80005c30:	9381                	srli	a5,a5,0x20
    80005c32:	97b2                	add	a5,a5,a2
    80005c34:	0007c783          	lbu	a5,0(a5)
    80005c38:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c3c:	0005079b          	sext.w	a5,a0
    80005c40:	02b5553b          	divuw	a0,a0,a1
    80005c44:	0685                	addi	a3,a3,1
    80005c46:	feb7f0e3          	bgeu	a5,a1,80005c26 <printint+0x26>

  if(sign)
    80005c4a:	00088b63          	beqz	a7,80005c60 <printint+0x60>
    buf[i++] = '-';
    80005c4e:	fe040793          	addi	a5,s0,-32
    80005c52:	973e                	add	a4,a4,a5
    80005c54:	02d00793          	li	a5,45
    80005c58:	fef70823          	sb	a5,-16(a4)
    80005c5c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c60:	02e05763          	blez	a4,80005c8e <printint+0x8e>
    80005c64:	fd040793          	addi	a5,s0,-48
    80005c68:	00e784b3          	add	s1,a5,a4
    80005c6c:	fff78913          	addi	s2,a5,-1
    80005c70:	993a                	add	s2,s2,a4
    80005c72:	377d                	addiw	a4,a4,-1
    80005c74:	1702                	slli	a4,a4,0x20
    80005c76:	9301                	srli	a4,a4,0x20
    80005c78:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c7c:	fff4c503          	lbu	a0,-1(s1)
    80005c80:	00000097          	auipc	ra,0x0
    80005c84:	d60080e7          	jalr	-672(ra) # 800059e0 <consputc>
  while(--i >= 0)
    80005c88:	14fd                	addi	s1,s1,-1
    80005c8a:	ff2499e3          	bne	s1,s2,80005c7c <printint+0x7c>
}
    80005c8e:	70a2                	ld	ra,40(sp)
    80005c90:	7402                	ld	s0,32(sp)
    80005c92:	64e2                	ld	s1,24(sp)
    80005c94:	6942                	ld	s2,16(sp)
    80005c96:	6145                	addi	sp,sp,48
    80005c98:	8082                	ret
    x = -xx;
    80005c9a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c9e:	4885                	li	a7,1
    x = -xx;
    80005ca0:	bf9d                	j	80005c16 <printint+0x16>

0000000080005ca2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ca2:	1101                	addi	sp,sp,-32
    80005ca4:	ec06                	sd	ra,24(sp)
    80005ca6:	e822                	sd	s0,16(sp)
    80005ca8:	e426                	sd	s1,8(sp)
    80005caa:	1000                	addi	s0,sp,32
    80005cac:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cae:	0001c797          	auipc	a5,0x1c
    80005cb2:	2007a123          	sw	zero,514(a5) # 80021eb0 <pr+0x18>
  printf("panic: ");
    80005cb6:	00003517          	auipc	a0,0x3
    80005cba:	cd250513          	addi	a0,a0,-814 # 80008988 <syscall_list+0x3f8>
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	02e080e7          	jalr	46(ra) # 80005cec <printf>
  printf(s);
    80005cc6:	8526                	mv	a0,s1
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	024080e7          	jalr	36(ra) # 80005cec <printf>
  printf("\n");
    80005cd0:	00002517          	auipc	a0,0x2
    80005cd4:	37850513          	addi	a0,a0,888 # 80008048 <etext+0x48>
    80005cd8:	00000097          	auipc	ra,0x0
    80005cdc:	014080e7          	jalr	20(ra) # 80005cec <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce0:	4785                	li	a5,1
    80005ce2:	00003717          	auipc	a4,0x3
    80005ce6:	d8f72523          	sw	a5,-630(a4) # 80008a6c <panicked>
  for(;;)
    80005cea:	a001                	j	80005cea <panic+0x48>

0000000080005cec <printf>:
{
    80005cec:	7131                	addi	sp,sp,-192
    80005cee:	fc86                	sd	ra,120(sp)
    80005cf0:	f8a2                	sd	s0,112(sp)
    80005cf2:	f4a6                	sd	s1,104(sp)
    80005cf4:	f0ca                	sd	s2,96(sp)
    80005cf6:	ecce                	sd	s3,88(sp)
    80005cf8:	e8d2                	sd	s4,80(sp)
    80005cfa:	e4d6                	sd	s5,72(sp)
    80005cfc:	e0da                	sd	s6,64(sp)
    80005cfe:	fc5e                	sd	s7,56(sp)
    80005d00:	f862                	sd	s8,48(sp)
    80005d02:	f466                	sd	s9,40(sp)
    80005d04:	f06a                	sd	s10,32(sp)
    80005d06:	ec6e                	sd	s11,24(sp)
    80005d08:	0100                	addi	s0,sp,128
    80005d0a:	8a2a                	mv	s4,a0
    80005d0c:	e40c                	sd	a1,8(s0)
    80005d0e:	e810                	sd	a2,16(s0)
    80005d10:	ec14                	sd	a3,24(s0)
    80005d12:	f018                	sd	a4,32(s0)
    80005d14:	f41c                	sd	a5,40(s0)
    80005d16:	03043823          	sd	a6,48(s0)
    80005d1a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d1e:	0001cd97          	auipc	s11,0x1c
    80005d22:	192dad83          	lw	s11,402(s11) # 80021eb0 <pr+0x18>
  if(locking)
    80005d26:	020d9b63          	bnez	s11,80005d5c <printf+0x70>
  if (fmt == 0)
    80005d2a:	040a0263          	beqz	s4,80005d6e <printf+0x82>
  va_start(ap, fmt);
    80005d2e:	00840793          	addi	a5,s0,8
    80005d32:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d36:	000a4503          	lbu	a0,0(s4)
    80005d3a:	16050263          	beqz	a0,80005e9e <printf+0x1b2>
    80005d3e:	4481                	li	s1,0
    if(c != '%'){
    80005d40:	02500a93          	li	s5,37
    switch(c){
    80005d44:	07000b13          	li	s6,112
  consputc('x');
    80005d48:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d4a:	00003b97          	auipc	s7,0x3
    80005d4e:	c66b8b93          	addi	s7,s7,-922 # 800089b0 <digits>
    switch(c){
    80005d52:	07300c93          	li	s9,115
    80005d56:	06400c13          	li	s8,100
    80005d5a:	a82d                	j	80005d94 <printf+0xa8>
    acquire(&pr.lock);
    80005d5c:	0001c517          	auipc	a0,0x1c
    80005d60:	13c50513          	addi	a0,a0,316 # 80021e98 <pr>
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	488080e7          	jalr	1160(ra) # 800061ec <acquire>
    80005d6c:	bf7d                	j	80005d2a <printf+0x3e>
    panic("null fmt");
    80005d6e:	00003517          	auipc	a0,0x3
    80005d72:	c2a50513          	addi	a0,a0,-982 # 80008998 <syscall_list+0x408>
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	f2c080e7          	jalr	-212(ra) # 80005ca2 <panic>
      consputc(c);
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	c62080e7          	jalr	-926(ra) # 800059e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d86:	2485                	addiw	s1,s1,1
    80005d88:	009a07b3          	add	a5,s4,s1
    80005d8c:	0007c503          	lbu	a0,0(a5)
    80005d90:	10050763          	beqz	a0,80005e9e <printf+0x1b2>
    if(c != '%'){
    80005d94:	ff5515e3          	bne	a0,s5,80005d7e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d98:	2485                	addiw	s1,s1,1
    80005d9a:	009a07b3          	add	a5,s4,s1
    80005d9e:	0007c783          	lbu	a5,0(a5)
    80005da2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005da6:	cfe5                	beqz	a5,80005e9e <printf+0x1b2>
    switch(c){
    80005da8:	05678a63          	beq	a5,s6,80005dfc <printf+0x110>
    80005dac:	02fb7663          	bgeu	s6,a5,80005dd8 <printf+0xec>
    80005db0:	09978963          	beq	a5,s9,80005e42 <printf+0x156>
    80005db4:	07800713          	li	a4,120
    80005db8:	0ce79863          	bne	a5,a4,80005e88 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005dbc:	f8843783          	ld	a5,-120(s0)
    80005dc0:	00878713          	addi	a4,a5,8
    80005dc4:	f8e43423          	sd	a4,-120(s0)
    80005dc8:	4605                	li	a2,1
    80005dca:	85ea                	mv	a1,s10
    80005dcc:	4388                	lw	a0,0(a5)
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	e32080e7          	jalr	-462(ra) # 80005c00 <printint>
      break;
    80005dd6:	bf45                	j	80005d86 <printf+0x9a>
    switch(c){
    80005dd8:	0b578263          	beq	a5,s5,80005e7c <printf+0x190>
    80005ddc:	0b879663          	bne	a5,s8,80005e88 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005de0:	f8843783          	ld	a5,-120(s0)
    80005de4:	00878713          	addi	a4,a5,8
    80005de8:	f8e43423          	sd	a4,-120(s0)
    80005dec:	4605                	li	a2,1
    80005dee:	45a9                	li	a1,10
    80005df0:	4388                	lw	a0,0(a5)
    80005df2:	00000097          	auipc	ra,0x0
    80005df6:	e0e080e7          	jalr	-498(ra) # 80005c00 <printint>
      break;
    80005dfa:	b771                	j	80005d86 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dfc:	f8843783          	ld	a5,-120(s0)
    80005e00:	00878713          	addi	a4,a5,8
    80005e04:	f8e43423          	sd	a4,-120(s0)
    80005e08:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e0c:	03000513          	li	a0,48
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	bd0080e7          	jalr	-1072(ra) # 800059e0 <consputc>
  consputc('x');
    80005e18:	07800513          	li	a0,120
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	bc4080e7          	jalr	-1084(ra) # 800059e0 <consputc>
    80005e24:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e26:	03c9d793          	srli	a5,s3,0x3c
    80005e2a:	97de                	add	a5,a5,s7
    80005e2c:	0007c503          	lbu	a0,0(a5)
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	bb0080e7          	jalr	-1104(ra) # 800059e0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e38:	0992                	slli	s3,s3,0x4
    80005e3a:	397d                	addiw	s2,s2,-1
    80005e3c:	fe0915e3          	bnez	s2,80005e26 <printf+0x13a>
    80005e40:	b799                	j	80005d86 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e42:	f8843783          	ld	a5,-120(s0)
    80005e46:	00878713          	addi	a4,a5,8
    80005e4a:	f8e43423          	sd	a4,-120(s0)
    80005e4e:	0007b903          	ld	s2,0(a5)
    80005e52:	00090e63          	beqz	s2,80005e6e <printf+0x182>
      for(; *s; s++)
    80005e56:	00094503          	lbu	a0,0(s2)
    80005e5a:	d515                	beqz	a0,80005d86 <printf+0x9a>
        consputc(*s);
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	b84080e7          	jalr	-1148(ra) # 800059e0 <consputc>
      for(; *s; s++)
    80005e64:	0905                	addi	s2,s2,1
    80005e66:	00094503          	lbu	a0,0(s2)
    80005e6a:	f96d                	bnez	a0,80005e5c <printf+0x170>
    80005e6c:	bf29                	j	80005d86 <printf+0x9a>
        s = "(null)";
    80005e6e:	00003917          	auipc	s2,0x3
    80005e72:	b2290913          	addi	s2,s2,-1246 # 80008990 <syscall_list+0x400>
      for(; *s; s++)
    80005e76:	02800513          	li	a0,40
    80005e7a:	b7cd                	j	80005e5c <printf+0x170>
      consputc('%');
    80005e7c:	8556                	mv	a0,s5
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	b62080e7          	jalr	-1182(ra) # 800059e0 <consputc>
      break;
    80005e86:	b701                	j	80005d86 <printf+0x9a>
      consputc('%');
    80005e88:	8556                	mv	a0,s5
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	b56080e7          	jalr	-1194(ra) # 800059e0 <consputc>
      consputc(c);
    80005e92:	854a                	mv	a0,s2
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	b4c080e7          	jalr	-1204(ra) # 800059e0 <consputc>
      break;
    80005e9c:	b5ed                	j	80005d86 <printf+0x9a>
  if(locking)
    80005e9e:	020d9163          	bnez	s11,80005ec0 <printf+0x1d4>
}
    80005ea2:	70e6                	ld	ra,120(sp)
    80005ea4:	7446                	ld	s0,112(sp)
    80005ea6:	74a6                	ld	s1,104(sp)
    80005ea8:	7906                	ld	s2,96(sp)
    80005eaa:	69e6                	ld	s3,88(sp)
    80005eac:	6a46                	ld	s4,80(sp)
    80005eae:	6aa6                	ld	s5,72(sp)
    80005eb0:	6b06                	ld	s6,64(sp)
    80005eb2:	7be2                	ld	s7,56(sp)
    80005eb4:	7c42                	ld	s8,48(sp)
    80005eb6:	7ca2                	ld	s9,40(sp)
    80005eb8:	7d02                	ld	s10,32(sp)
    80005eba:	6de2                	ld	s11,24(sp)
    80005ebc:	6129                	addi	sp,sp,192
    80005ebe:	8082                	ret
    release(&pr.lock);
    80005ec0:	0001c517          	auipc	a0,0x1c
    80005ec4:	fd850513          	addi	a0,a0,-40 # 80021e98 <pr>
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	3d8080e7          	jalr	984(ra) # 800062a0 <release>
}
    80005ed0:	bfc9                	j	80005ea2 <printf+0x1b6>

0000000080005ed2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ed2:	1101                	addi	sp,sp,-32
    80005ed4:	ec06                	sd	ra,24(sp)
    80005ed6:	e822                	sd	s0,16(sp)
    80005ed8:	e426                	sd	s1,8(sp)
    80005eda:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005edc:	0001c497          	auipc	s1,0x1c
    80005ee0:	fbc48493          	addi	s1,s1,-68 # 80021e98 <pr>
    80005ee4:	00003597          	auipc	a1,0x3
    80005ee8:	ac458593          	addi	a1,a1,-1340 # 800089a8 <syscall_list+0x418>
    80005eec:	8526                	mv	a0,s1
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	26e080e7          	jalr	622(ra) # 8000615c <initlock>
  pr.locking = 1;
    80005ef6:	4785                	li	a5,1
    80005ef8:	cc9c                	sw	a5,24(s1)
}
    80005efa:	60e2                	ld	ra,24(sp)
    80005efc:	6442                	ld	s0,16(sp)
    80005efe:	64a2                	ld	s1,8(sp)
    80005f00:	6105                	addi	sp,sp,32
    80005f02:	8082                	ret

0000000080005f04 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f04:	1141                	addi	sp,sp,-16
    80005f06:	e406                	sd	ra,8(sp)
    80005f08:	e022                	sd	s0,0(sp)
    80005f0a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f0c:	100007b7          	lui	a5,0x10000
    80005f10:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f14:	f8000713          	li	a4,-128
    80005f18:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f1c:	470d                	li	a4,3
    80005f1e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f22:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f26:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f2a:	469d                	li	a3,7
    80005f2c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f30:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f34:	00003597          	auipc	a1,0x3
    80005f38:	a9458593          	addi	a1,a1,-1388 # 800089c8 <digits+0x18>
    80005f3c:	0001c517          	auipc	a0,0x1c
    80005f40:	f7c50513          	addi	a0,a0,-132 # 80021eb8 <uart_tx_lock>
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	218080e7          	jalr	536(ra) # 8000615c <initlock>
}
    80005f4c:	60a2                	ld	ra,8(sp)
    80005f4e:	6402                	ld	s0,0(sp)
    80005f50:	0141                	addi	sp,sp,16
    80005f52:	8082                	ret

0000000080005f54 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f54:	1101                	addi	sp,sp,-32
    80005f56:	ec06                	sd	ra,24(sp)
    80005f58:	e822                	sd	s0,16(sp)
    80005f5a:	e426                	sd	s1,8(sp)
    80005f5c:	1000                	addi	s0,sp,32
    80005f5e:	84aa                	mv	s1,a0
  push_off();
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	240080e7          	jalr	576(ra) # 800061a0 <push_off>

  if(panicked){
    80005f68:	00003797          	auipc	a5,0x3
    80005f6c:	b047a783          	lw	a5,-1276(a5) # 80008a6c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f70:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f74:	c391                	beqz	a5,80005f78 <uartputc_sync+0x24>
    for(;;)
    80005f76:	a001                	j	80005f76 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f78:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f7c:	0ff7f793          	andi	a5,a5,255
    80005f80:	0207f793          	andi	a5,a5,32
    80005f84:	dbf5                	beqz	a5,80005f78 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f86:	0ff4f793          	andi	a5,s1,255
    80005f8a:	10000737          	lui	a4,0x10000
    80005f8e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	2ae080e7          	jalr	686(ra) # 80006240 <pop_off>
}
    80005f9a:	60e2                	ld	ra,24(sp)
    80005f9c:	6442                	ld	s0,16(sp)
    80005f9e:	64a2                	ld	s1,8(sp)
    80005fa0:	6105                	addi	sp,sp,32
    80005fa2:	8082                	ret

0000000080005fa4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fa4:	00003717          	auipc	a4,0x3
    80005fa8:	acc73703          	ld	a4,-1332(a4) # 80008a70 <uart_tx_r>
    80005fac:	00003797          	auipc	a5,0x3
    80005fb0:	acc7b783          	ld	a5,-1332(a5) # 80008a78 <uart_tx_w>
    80005fb4:	06e78c63          	beq	a5,a4,8000602c <uartstart+0x88>
{
    80005fb8:	7139                	addi	sp,sp,-64
    80005fba:	fc06                	sd	ra,56(sp)
    80005fbc:	f822                	sd	s0,48(sp)
    80005fbe:	f426                	sd	s1,40(sp)
    80005fc0:	f04a                	sd	s2,32(sp)
    80005fc2:	ec4e                	sd	s3,24(sp)
    80005fc4:	e852                	sd	s4,16(sp)
    80005fc6:	e456                	sd	s5,8(sp)
    80005fc8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fca:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fce:	0001ca17          	auipc	s4,0x1c
    80005fd2:	eeaa0a13          	addi	s4,s4,-278 # 80021eb8 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd6:	00003497          	auipc	s1,0x3
    80005fda:	a9a48493          	addi	s1,s1,-1382 # 80008a70 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fde:	00003997          	auipc	s3,0x3
    80005fe2:	a9a98993          	addi	s3,s3,-1382 # 80008a78 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fe6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fea:	0ff7f793          	andi	a5,a5,255
    80005fee:	0207f793          	andi	a5,a5,32
    80005ff2:	c785                	beqz	a5,8000601a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ff4:	01f77793          	andi	a5,a4,31
    80005ff8:	97d2                	add	a5,a5,s4
    80005ffa:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ffe:	0705                	addi	a4,a4,1
    80006000:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006002:	8526                	mv	a0,s1
    80006004:	ffffb097          	auipc	ra,0xffffb
    80006008:	5c0080e7          	jalr	1472(ra) # 800015c4 <wakeup>
    
    WriteReg(THR, c);
    8000600c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006010:	6098                	ld	a4,0(s1)
    80006012:	0009b783          	ld	a5,0(s3)
    80006016:	fce798e3          	bne	a5,a4,80005fe6 <uartstart+0x42>
  }
}
    8000601a:	70e2                	ld	ra,56(sp)
    8000601c:	7442                	ld	s0,48(sp)
    8000601e:	74a2                	ld	s1,40(sp)
    80006020:	7902                	ld	s2,32(sp)
    80006022:	69e2                	ld	s3,24(sp)
    80006024:	6a42                	ld	s4,16(sp)
    80006026:	6aa2                	ld	s5,8(sp)
    80006028:	6121                	addi	sp,sp,64
    8000602a:	8082                	ret
    8000602c:	8082                	ret

000000008000602e <uartputc>:
{
    8000602e:	7179                	addi	sp,sp,-48
    80006030:	f406                	sd	ra,40(sp)
    80006032:	f022                	sd	s0,32(sp)
    80006034:	ec26                	sd	s1,24(sp)
    80006036:	e84a                	sd	s2,16(sp)
    80006038:	e44e                	sd	s3,8(sp)
    8000603a:	e052                	sd	s4,0(sp)
    8000603c:	1800                	addi	s0,sp,48
    8000603e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006040:	0001c517          	auipc	a0,0x1c
    80006044:	e7850513          	addi	a0,a0,-392 # 80021eb8 <uart_tx_lock>
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	1a4080e7          	jalr	420(ra) # 800061ec <acquire>
  if(panicked){
    80006050:	00003797          	auipc	a5,0x3
    80006054:	a1c7a783          	lw	a5,-1508(a5) # 80008a6c <panicked>
    80006058:	e7c9                	bnez	a5,800060e2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605a:	00003797          	auipc	a5,0x3
    8000605e:	a1e7b783          	ld	a5,-1506(a5) # 80008a78 <uart_tx_w>
    80006062:	00003717          	auipc	a4,0x3
    80006066:	a0e73703          	ld	a4,-1522(a4) # 80008a70 <uart_tx_r>
    8000606a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000606e:	0001ca17          	auipc	s4,0x1c
    80006072:	e4aa0a13          	addi	s4,s4,-438 # 80021eb8 <uart_tx_lock>
    80006076:	00003497          	auipc	s1,0x3
    8000607a:	9fa48493          	addi	s1,s1,-1542 # 80008a70 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607e:	00003917          	auipc	s2,0x3
    80006082:	9fa90913          	addi	s2,s2,-1542 # 80008a78 <uart_tx_w>
    80006086:	00f71f63          	bne	a4,a5,800060a4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000608a:	85d2                	mv	a1,s4
    8000608c:	8526                	mv	a0,s1
    8000608e:	ffffb097          	auipc	ra,0xffffb
    80006092:	4d2080e7          	jalr	1234(ra) # 80001560 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006096:	00093783          	ld	a5,0(s2)
    8000609a:	6098                	ld	a4,0(s1)
    8000609c:	02070713          	addi	a4,a4,32
    800060a0:	fef705e3          	beq	a4,a5,8000608a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060a4:	0001c497          	auipc	s1,0x1c
    800060a8:	e1448493          	addi	s1,s1,-492 # 80021eb8 <uart_tx_lock>
    800060ac:	01f7f713          	andi	a4,a5,31
    800060b0:	9726                	add	a4,a4,s1
    800060b2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800060b6:	0785                	addi	a5,a5,1
    800060b8:	00003717          	auipc	a4,0x3
    800060bc:	9cf73023          	sd	a5,-1600(a4) # 80008a78 <uart_tx_w>
  uartstart();
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	ee4080e7          	jalr	-284(ra) # 80005fa4 <uartstart>
  release(&uart_tx_lock);
    800060c8:	8526                	mv	a0,s1
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	1d6080e7          	jalr	470(ra) # 800062a0 <release>
}
    800060d2:	70a2                	ld	ra,40(sp)
    800060d4:	7402                	ld	s0,32(sp)
    800060d6:	64e2                	ld	s1,24(sp)
    800060d8:	6942                	ld	s2,16(sp)
    800060da:	69a2                	ld	s3,8(sp)
    800060dc:	6a02                	ld	s4,0(sp)
    800060de:	6145                	addi	sp,sp,48
    800060e0:	8082                	ret
    for(;;)
    800060e2:	a001                	j	800060e2 <uartputc+0xb4>

00000000800060e4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060e4:	1141                	addi	sp,sp,-16
    800060e6:	e422                	sd	s0,8(sp)
    800060e8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060ea:	100007b7          	lui	a5,0x10000
    800060ee:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060f2:	8b85                	andi	a5,a5,1
    800060f4:	cb91                	beqz	a5,80006108 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060f6:	100007b7          	lui	a5,0x10000
    800060fa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060fe:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006102:	6422                	ld	s0,8(sp)
    80006104:	0141                	addi	sp,sp,16
    80006106:	8082                	ret
    return -1;
    80006108:	557d                	li	a0,-1
    8000610a:	bfe5                	j	80006102 <uartgetc+0x1e>

000000008000610c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000610c:	1101                	addi	sp,sp,-32
    8000610e:	ec06                	sd	ra,24(sp)
    80006110:	e822                	sd	s0,16(sp)
    80006112:	e426                	sd	s1,8(sp)
    80006114:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006116:	54fd                	li	s1,-1
    int c = uartgetc();
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	fcc080e7          	jalr	-52(ra) # 800060e4 <uartgetc>
    if(c == -1)
    80006120:	00950763          	beq	a0,s1,8000612e <uartintr+0x22>
      break;
    consoleintr(c);
    80006124:	00000097          	auipc	ra,0x0
    80006128:	8fe080e7          	jalr	-1794(ra) # 80005a22 <consoleintr>
  while(1){
    8000612c:	b7f5                	j	80006118 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000612e:	0001c497          	auipc	s1,0x1c
    80006132:	d8a48493          	addi	s1,s1,-630 # 80021eb8 <uart_tx_lock>
    80006136:	8526                	mv	a0,s1
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	0b4080e7          	jalr	180(ra) # 800061ec <acquire>
  uartstart();
    80006140:	00000097          	auipc	ra,0x0
    80006144:	e64080e7          	jalr	-412(ra) # 80005fa4 <uartstart>
  release(&uart_tx_lock);
    80006148:	8526                	mv	a0,s1
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	156080e7          	jalr	342(ra) # 800062a0 <release>
}
    80006152:	60e2                	ld	ra,24(sp)
    80006154:	6442                	ld	s0,16(sp)
    80006156:	64a2                	ld	s1,8(sp)
    80006158:	6105                	addi	sp,sp,32
    8000615a:	8082                	ret

000000008000615c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000615c:	1141                	addi	sp,sp,-16
    8000615e:	e422                	sd	s0,8(sp)
    80006160:	0800                	addi	s0,sp,16
  lk->name = name;
    80006162:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006164:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006168:	00053823          	sd	zero,16(a0)
}
    8000616c:	6422                	ld	s0,8(sp)
    8000616e:	0141                	addi	sp,sp,16
    80006170:	8082                	ret

0000000080006172 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006172:	411c                	lw	a5,0(a0)
    80006174:	e399                	bnez	a5,8000617a <holding+0x8>
    80006176:	4501                	li	a0,0
  return r;
}
    80006178:	8082                	ret
{
    8000617a:	1101                	addi	sp,sp,-32
    8000617c:	ec06                	sd	ra,24(sp)
    8000617e:	e822                	sd	s0,16(sp)
    80006180:	e426                	sd	s1,8(sp)
    80006182:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006184:	6904                	ld	s1,16(a0)
    80006186:	ffffb097          	auipc	ra,0xffffb
    8000618a:	d0e080e7          	jalr	-754(ra) # 80000e94 <mycpu>
    8000618e:	40a48533          	sub	a0,s1,a0
    80006192:	00153513          	seqz	a0,a0
}
    80006196:	60e2                	ld	ra,24(sp)
    80006198:	6442                	ld	s0,16(sp)
    8000619a:	64a2                	ld	s1,8(sp)
    8000619c:	6105                	addi	sp,sp,32
    8000619e:	8082                	ret

00000000800061a0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061aa:	100024f3          	csrr	s1,sstatus
    800061ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061b2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061b4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061b8:	ffffb097          	auipc	ra,0xffffb
    800061bc:	cdc080e7          	jalr	-804(ra) # 80000e94 <mycpu>
    800061c0:	5d3c                	lw	a5,120(a0)
    800061c2:	cf89                	beqz	a5,800061dc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061c4:	ffffb097          	auipc	ra,0xffffb
    800061c8:	cd0080e7          	jalr	-816(ra) # 80000e94 <mycpu>
    800061cc:	5d3c                	lw	a5,120(a0)
    800061ce:	2785                	addiw	a5,a5,1
    800061d0:	dd3c                	sw	a5,120(a0)
}
    800061d2:	60e2                	ld	ra,24(sp)
    800061d4:	6442                	ld	s0,16(sp)
    800061d6:	64a2                	ld	s1,8(sp)
    800061d8:	6105                	addi	sp,sp,32
    800061da:	8082                	ret
    mycpu()->intena = old;
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	cb8080e7          	jalr	-840(ra) # 80000e94 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061e4:	8085                	srli	s1,s1,0x1
    800061e6:	8885                	andi	s1,s1,1
    800061e8:	dd64                	sw	s1,124(a0)
    800061ea:	bfe9                	j	800061c4 <push_off+0x24>

00000000800061ec <acquire>:
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	fa8080e7          	jalr	-88(ra) # 800061a0 <push_off>
  if(holding(lk))
    80006200:	8526                	mv	a0,s1
    80006202:	00000097          	auipc	ra,0x0
    80006206:	f70080e7          	jalr	-144(ra) # 80006172 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000620a:	4705                	li	a4,1
  if(holding(lk))
    8000620c:	e115                	bnez	a0,80006230 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000620e:	87ba                	mv	a5,a4
    80006210:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006214:	2781                	sext.w	a5,a5
    80006216:	ffe5                	bnez	a5,8000620e <acquire+0x22>
  __sync_synchronize();
    80006218:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000621c:	ffffb097          	auipc	ra,0xffffb
    80006220:	c78080e7          	jalr	-904(ra) # 80000e94 <mycpu>
    80006224:	e888                	sd	a0,16(s1)
}
    80006226:	60e2                	ld	ra,24(sp)
    80006228:	6442                	ld	s0,16(sp)
    8000622a:	64a2                	ld	s1,8(sp)
    8000622c:	6105                	addi	sp,sp,32
    8000622e:	8082                	ret
    panic("acquire");
    80006230:	00002517          	auipc	a0,0x2
    80006234:	7a050513          	addi	a0,a0,1952 # 800089d0 <digits+0x20>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	a6a080e7          	jalr	-1430(ra) # 80005ca2 <panic>

0000000080006240 <pop_off>:

void
pop_off(void)
{
    80006240:	1141                	addi	sp,sp,-16
    80006242:	e406                	sd	ra,8(sp)
    80006244:	e022                	sd	s0,0(sp)
    80006246:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	c4c080e7          	jalr	-948(ra) # 80000e94 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006250:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006254:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006256:	e78d                	bnez	a5,80006280 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006258:	5d3c                	lw	a5,120(a0)
    8000625a:	02f05b63          	blez	a5,80006290 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000625e:	37fd                	addiw	a5,a5,-1
    80006260:	0007871b          	sext.w	a4,a5
    80006264:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006266:	eb09                	bnez	a4,80006278 <pop_off+0x38>
    80006268:	5d7c                	lw	a5,124(a0)
    8000626a:	c799                	beqz	a5,80006278 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000626c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006270:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006274:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006278:	60a2                	ld	ra,8(sp)
    8000627a:	6402                	ld	s0,0(sp)
    8000627c:	0141                	addi	sp,sp,16
    8000627e:	8082                	ret
    panic("pop_off - interruptible");
    80006280:	00002517          	auipc	a0,0x2
    80006284:	75850513          	addi	a0,a0,1880 # 800089d8 <digits+0x28>
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	a1a080e7          	jalr	-1510(ra) # 80005ca2 <panic>
    panic("pop_off");
    80006290:	00002517          	auipc	a0,0x2
    80006294:	76050513          	addi	a0,a0,1888 # 800089f0 <digits+0x40>
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	a0a080e7          	jalr	-1526(ra) # 80005ca2 <panic>

00000000800062a0 <release>:
{
    800062a0:	1101                	addi	sp,sp,-32
    800062a2:	ec06                	sd	ra,24(sp)
    800062a4:	e822                	sd	s0,16(sp)
    800062a6:	e426                	sd	s1,8(sp)
    800062a8:	1000                	addi	s0,sp,32
    800062aa:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	ec6080e7          	jalr	-314(ra) # 80006172 <holding>
    800062b4:	c115                	beqz	a0,800062d8 <release+0x38>
  lk->cpu = 0;
    800062b6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062ba:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062be:	0f50000f          	fence	iorw,ow
    800062c2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	f7a080e7          	jalr	-134(ra) # 80006240 <pop_off>
}
    800062ce:	60e2                	ld	ra,24(sp)
    800062d0:	6442                	ld	s0,16(sp)
    800062d2:	64a2                	ld	s1,8(sp)
    800062d4:	6105                	addi	sp,sp,32
    800062d6:	8082                	ret
    panic("release");
    800062d8:	00002517          	auipc	a0,0x2
    800062dc:	72050513          	addi	a0,a0,1824 # 800089f8 <digits+0x48>
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	9c2080e7          	jalr	-1598(ra) # 80005ca2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
