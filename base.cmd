-e START
MEMORY
{
	PAGE 0:
			PARAM: org = 3000h	len = 4000h
	PAGE 1:
			DARAM: org = 100h	len = 4000h
}
SECTIONS
{
	.text		:> PARAM PAGE 0
	stack		:> DARAM PAGE 1
	filter_vars	:> DARAM PAGE 1
	.bss		:> DARAM PAGE 1
	.data		:> DARAM PAGE 1
}
