#coding=utf8
import sys
from xml.dom.minidom import parse

# 待解析 XMI 文件
xmi_filename = 'object.xmi'

# 生成的 prolog 文件
pl_filename = '%s.pl'%xmi_filename.split('.')[0]


# 编码信息
input_encoding = sys.stdin.encoding
output_encoding = sys.stdout.encoding
file_encoding = 'utf8'

def printx(s, end = '\n'):
    '''通用输出'''
    '''可输出 str、dict 类型'''
    '''可自动转换编码'''
    if output_encoding == None:
        sys.stdout.write(s)
        sys.stdout.write('\n')
    elif isinstance(s,str):
        # s = s.decode(file_encoding)
        s += end
        # s = s.encode(output_encoding)
        sys.stdout.write(s)
    elif isinstance(s,dict):
        s = json.dumps(s, indent=4, ensure_ascii=False)
        s += end
        s = s.encode(output_encoding)
        sys.stdout.write(s)
    else:
        print(s)
    sys.stdout.flush()



# 解析 XMI 文档，生成 DOM tree
printx('开始解析 XMI 文件……')
DOMTree = parse(xmi_filename)
collection = DOMTree.documentElement

# ID递增记录
term_cnt = {
    'c' : 1,    # class
    'a' : 1,    # attribute
    'o' : 1,    # operation
    'p' : 1,    # parameter
    's' : 1,    # association
    'r' : 1,    # rolename
    'm' : 1,    # multiplicity
    'g' : 1,    # generalization
}

# 解析结果
Class_list = []
Attribute_list = []
PrimitiveTypes_list = []
Association_list = []
AssociationDetail_list = []
Multiplicity_list = []
Parameter_list = []
Operation_list = []
Generalization_list = []
Rolename_list = []

# id 映射表
idMap = {}

# 在集合中获取所有 packagedElement 元素
printx('正在解析UML图中的 类的基本信息 ……')
printx('正在解析UML图中的 基本类型 ……')
printx('正在解析UML图中的 关联关系 ……')
items = collection.getElementsByTagName('packagedElement')

# 处理每个 packagedElement 元素
for item in items:
    element = {
        'xmi:id' : item.getAttribute('xmi:id'),
        'xmi:type' : item.getAttribute('xmi:type'),
        'name' : item.getAttribute('name'),
    }
    if item.getAttribute('xmi:type') == 'uml:Class':
        element['id'] = 'c%d'%term_cnt['c']
        idMap[element['xmi:id']] = element['id']
        term_cnt['c'] += 1
        Class_list.append(element)

    elif item.getAttribute('xmi:type') == 'uml:PrimitiveType':
        idMap[element['xmi:id']] = element['name']
        PrimitiveTypes_list.append(element)

    elif item.getAttribute('xmi:type') == 'uml:Association':
    	# 关联关系
        element['id'] = 's%d'%term_cnt['s']
        element['memberEnd'] = item.getAttribute('memberEnd').split()
        idMap[element['xmi:id']] = element['id']
        term_cnt['s'] += 1
        Association_list.append(element)


# 获取所有 ownedAttribute 元素
printx('正在解析UML图中的 关联详情 ……')
printx('正在解析UML图中的 多重性 ……')
printx('正在解析UML图中的 类的属性 ……')
items = collection.getElementsByTagName('ownedAttribute')

# 处理每个 ownedAttribute 元素
for item in items:
    element = {
        'type' : item.getAttribute('type'),
        'xmi:id' : item.getAttribute('xmi:id'),
        'xmi:type' : item.getAttribute('xmi:type'),
        'visibility' : item.getAttribute('visibility'),
        'classid' : idMap[item.parentNode.getAttribute('xmi:id')],
    }
    if item.hasAttribute('association'):
        # 关联详情
        element['name'] = item.parentNode.getAttribute('name').lower() if item.getAttribute('name') == '' else item.getAttribute('name')
        element['association'] = item.getAttribute('association')

        idMap[element['xmi:id']] = { 'classid' : element['classid'], 'name' : element['name'] }
        AssociationDetail_list.append(element)

        # 多重性
        elist = item.childNodes
        # 如果不包含 lowerValue 和 upperValue 就退出当前循环
        if len(elist) == 0:
            continue
        element = {
            'Endid' : 'm%d'%term_cnt['m'],
            'Classid' : idMap[item.getAttribute('xmi:id')]['classid'],
            'Associd' : idMap[item.getAttribute('association')],
        }
        # 取出 lowerValue 和 upperValue
        for e in elist:
            if e.nodeName == 'lowerValue' or e.nodeName == 'upperValue':
        		  key = 'Lowval' if e.nodeName == 'lowerValue' else 'Upval'
        	    if e.hasAttribute('value'):
        			element[key] = 'n' if e.getAttribute('value')=='*' else e.getAttribute('value')
        		else:
        			element[key] = '0'
        term_cnt['m'] += 1
        Multiplicity_list.append(element)

    else:
        # 属性
        element['id'] = 'a%d'%term_cnt['a']
        element['name'] = item.getAttribute('name')
        element['attrtype'] = idMap[item.getAttribute('type')]
        
        term_cnt['a'] += 1
        Attribute_list.append(element)


# 处理角色
printx('正在解析UML图中的 角色 ……')
for Association in Association_list:
	element = {
	    'Roleid' : 'r%d'%term_cnt['r'],
	    'nameA' : idMap[Association['memberEnd'][1]]['name'],
	    'nameB' : idMap[Association['memberEnd'][0]]['name'],
	    'Associd' : Association['id'],
	}
	Rolename_list.append(element)
	term_cnt['r'] += 1


# 获取所有 ownedParameter 元素
printx('正在解析UML图中的 参数信息 ……')
items = collection.getElementsByTagName('ownedParameter')

# 处理每个 ownedParameter 元素
for item in items:
	if item.hasAttribute('name'):
		# 是函数参数
	    element = {
	        'id' : 'p%d'%term_cnt['p'],
	        'name' : item.getAttribute('name'),
	        'xmi:id' : item.getAttribute('xmi:id'),
	        'xmi:type' : item.getAttribute('xmi:type'),
	        'classid' : idMap[item.getAttribute('type')],
	    }
	    idMap[element['classid']] = element['id']
	    term_cnt['p'] += 1
	    Parameter_list.append(element)


# 获取所有 ownedOperation 元素
printx('正在解析UML图中的 类的操作 ……')
items = collection.getElementsByTagName('ownedOperation')

# 处理每个 ownedOperation 元素
for item in items:
    element = {
        'id' : 'o%d'%term_cnt['o'],
        'name' : item.getAttribute('name'),
        'visibility' : item.getAttribute('visibility'),
        'xmi:id' : item.getAttribute('xmi:id'),
        'xmi:type' : item.getAttribute('xmi:type'),
        'classid' : idMap[item.parentNode.getAttribute('xmi:id')],
        'parametersid' : [],
    }
    # 添加 parametersid 列表内容
    for p in item.childNodes:
        if p.nodeName == 'ownedParameter':
            if p.hasAttribute('name'):
            	element['parametersid'].append(idMap[idMap[p.getAttribute('type')]])
    term_cnt['o'] += 1
    Operation_list.append(element)



# 获取所有 generalization 元素
printx('正在解析UML图中的 泛化关系 ……')
items = collection.getElementsByTagName('generalization')

# 处理每个 generalization 元素
for item in items:
    element = {
        'Genid' : 'g%d'%term_cnt['g'],
        'general' : item.getAttribute('general'), 
        'xmi:id' : item.getAttribute('xmi:id'),
        'xmi:type' : item.getAttribute('xmi:type'),
        'Superid' : idMap[item.getAttribute('general')],
        'Subid' : idMap[item.parentNode.getAttribute('xmi:id')],
    }
    term_cnt['g'] += 1
    Generalization_list.append(element)


# 生成 prolog 代码
printx('XMI文件 解析完成！')
printx('正在转换成 prolog 文件 ……')
fp = open(pl_filename,'w')

# class 部分
for Class in Class_list:
    isAbstract = 'f' if Class['xmi:type'] == 'uml:Class' else 't'
    fp.write("class(%s, '%s', %s).\n"%(Class['id'], Class['name'], isAbstract))
fp.write('\n')

# attribute 部分
for Attribute in Attribute_list:
    fp.write('attribute(%s, %s, %s, %s).\n'%(Attribute['id'], Attribute['name'], Attribute['attrtype'], Attribute['classid']))
fp.write('\n')

# operation 部分
for Operation in Operation_list:
    fp.write('operation(%s, %s, [%s],  %s).\n'%(Operation['id'], Operation['name'], ','.join(Operation['parametersid']), Operation['classid']))
fp.write('\n')

# parameter 部分
for Parameter in Parameter_list:
    fp.write('parameter(%s, %s, %s).\n'%(Parameter['id'], Parameter['name'], Parameter['classid'] ))
fp.write('\n')

# association 部分
for Association in Association_list:
    fp.write('association(%s, %s, %s).\n'%(Association['id'], idMap[Association['memberEnd'][1]]['classid'], idMap[Association['memberEnd'][0]]['classid']))
fp.write('\n')

# rolename 部分
for Rolename in Rolename_list:
    fp.write('rolename(%s, %s, %s, %s).\n'%(Rolename['Roleid'], Rolename['nameA'], Rolename['nameB'], Rolename['Associd'] ))
fp.write('\n')

# multiplicity 部分
for Multiplicity in Multiplicity_list:
    fp.write('multiplicity(%s, %s, %s, %s, %s).\n'%(Multiplicity['Endid'], Multiplicity['Classid'], Multiplicity['Lowval'], Multiplicity['Upval'], Multiplicity['Associd'] ))
fp.write('\n')

# generalization 部分
for Generalization in Generalization_list:
    fp.write('generalization(%s, %s, %s).\n'%(Generalization['Genid'], Generalization['Superid'], Generalization['Subid'] ))
fp.write('\n')

fp.close()

printx('Prolog 文件已生成，见文件 【%s】！'%pl_filename)
