import pandas as pd
import numpy as np
import time

import pandas as pd
import numpy as np

class ChineseNames:
    def lookup(self,df, key, lookup_df, lookup_key, lookup_value):  # 用于查找数据
        if type(lookup_key) == list:
            df2 = lookup_df[lookup_key + [lookup_value]].copy()
            merged = pd.merge(df, df2, left_on=key, right_on=lookup_key, how='left', suffixes=('_suffix1', '_suffix2'))
            merged.drop(columns=merged.columns[merged.columns.str.contains('_suffix')].tolist(), inplace=True)
        else:
            df2 = lookup_df[[lookup_key, lookup_value]].copy()
            merged = pd.merge(df, df2, left_on=key, right_on=lookup_key, how='left')
        return merged[lookup_value]


    def recode(self,year, code_map):
        return year.apply(lambda x: next((v for k, v in code_map.items() if x in k), 0))


    def compute_NU_char(self,data, ref_long, var_char, var_year=None, approx=True):
        ppm1, ppm2, weight1, weight2 = None, None, None, None
        if var_year is None:
            ppm = self.lookup(data, var_char, ref_long, 'character', 'name.ppm')
        else:
            d = data[[var_char, var_year]].copy()
            d.columns = ['char', 'year']

            code_map = {
                range(0, 1930): 1,
                range(1930, 1960): 1,
                range(1960, 1970): 2,
                range(1970, 1980): 3,
                range(1980, 1990): 4,
                range(1990, 2000): 5,
                range(2000, 2010): 6
            }
            d['code'] = self.recode(d['year'], code_map)

            code1_map = {
                range(0, 1955): 1,
                range(1955, 1965): 1,
                range(1965, 1975): 2,
                range(1975, 1985): 3,
                range(1985, 1995): 4,
                range(1995, 2005): 5,
                range(2005, 2010): 6
            }
            d['code1'] = self.recode(d['year'], code1_map)

            code2_map = {
                range(0, 1955): 1,
                range(1955, 1965): 2,
                range(1965, 1975): 3,
                range(1975, 1985): 4,
                range(1985, 1995): 5,
                range(1995, 2005): 6,
                range(2005, 2010): 6
            }
            d['code2'] = self.recode(d['year'], code2_map)

            d['weight1'] = 5 - (d['year'] % 10)
            d['weight1'] = np.where(d['weight1'] > 0, d['weight1'], 10 + d['weight1'])
            d['weight1'] = np.where(d['weight1'].isna(), 5, d['weight1'])
            d['weight2'] = 10 - d['weight1']

            if not approx:
                d['ppm'] = self.lookup(d, ['char', 'code'], ref_long, ['char', 'code'], 'ppm')
            else:
                d['ppm1'] = self.lookup(d, ['char', 'code1'], ref_long, ['char', 'code'], 'ppm')
                d['ppm2'] = self.lookup(d, ['char', 'code2'], ref_long, ['char', 'code'], 'ppm')
                d['ppm'] = (d['ppm1'] * d['weight1'] + d['ppm2'] * d['weight2']) / 10

        # d['ppm'] = np.where((d['ppm'].isna() & d['char'].notna()) | (d['char'] != ""), np.nan, d['ppm'])
        d['ppm'] = np.where(d['char'] == "", np.nan, d['ppm'])
        return (-np.log10((d['ppm'] + 1) / 10 ** 6)).astype(float)


    def mean(self,df, prefix, cols):
        # 计算平均值,如果为nan则,不加入计算
        return df[[f"{prefix}{i}" for i in cols]].mean(axis=1)

    def compute_name_index(self,data=None, fullname=None, surname=None, givenname=None, birthyear=None,
                           name=None, birth=None, index=["NLen", "SNU", "SNI", "NU", "CCU", "NG", "NV", "NW", "NC"],
                           NU_approx=True, digits=4, return_namechar=True, return_all=False):
        '''
        NLen: Name length, 全名长度
        SNU: Surname uniqueness, 姓氏独特性
        SNI: Surname initial rank, 姓氏首字排名
        NU: Name uniqueness, 名字独特性
        CCU: Character corpus uniqueness, 字符语料库独特性(基于当代中文语料库中某个字符的使用频率来计算的独特性指标。与NU不同，CCU衡量的是日常语言使用中字符的流行度，而不是名字中的使用频率。)
        NG: Name gender, 名字性别
        NV: Name valence, 名字情感价值 基于16位中文评价者对2614个名字字符意义的积极程度的主观评分（1到5分）。
        NW: Name warmth, 名字温暖度/道德感 基于10位中文评价者对名字中包含的字符可能带来的温暖相关特质的主观评分（1到5分）。
        NC: Name competence, 名字能力/自信 基于10位中文评价者对名字中包含的字符可能带来的能力相关特质的主观评分（1到5分）。
        '''
        ## Prepare ##
        if data is not None and len(data) >= 1000:
            log = True
        else:
            log = False
        t0 = time.time()

        # Assuming familyname and givenname are already loaded as DataFrames
        familyname = pd.read_csv('/home/zsl/audrey_code/AI_Naming/dataset/name_data/familyname.csv')
        givenname = pd.read_csv('/home/zsl/audrey_code/AI_Naming/dataset/name_data/givenname.csv')

        fuxing = familyname[familyname['compound'] == 1]['surname']  # 1代表复姓,0代表单姓
        ref0 = pd.DataFrame({'char': givenname['character'], 'code': 0, 'ppm': givenname['name.ppm']})
        ref1 = pd.DataFrame({'char': givenname['character'], 'code': 1, 'ppm': givenname['ppm.1930_1959']})
        ref2 = pd.DataFrame({'char': givenname['character'], 'code': 2, 'ppm': givenname['ppm.1960_1969']})
        ref3 = pd.DataFrame({'char': givenname['character'], 'code': 3, 'ppm': givenname['ppm.1970_1979']})
        ref4 = pd.DataFrame({'char': givenname['character'], 'code': 4, 'ppm': givenname['ppm.1980_1989']})
        ref5 = pd.DataFrame({'char': givenname['character'], 'code': 5, 'ppm': givenname['ppm.1990_1999']})
        ref6 = pd.DataFrame({'char': givenname['character'], 'code': 6,
                             'ppm': givenname['ppm.2000_2008']})  # 频率 “ppm”表示“百万分率”（例如，1 ppm = 1/10 6的比例）。
        ref_long = pd.concat([ref0, ref1, ref2, ref3, ref4, ref5, ref6], ignore_index=True)

        ## Initialize ##
        NLen, SNU, SNI, NU, CCU, NG, NV, NW, NC = None, None, None, None, None, None, None, None, None
        if name is not None:
            data = pd.DataFrame({'name': name, 'birth': birth})
            fullname = "name"
            birthyear = "birth"
        if data is None:
            raise ValueError("Please input your data.")
        if fullname is None and surname is None and givenname is None:
            raise ValueError("Please input variable(s) of full/family/given names.")

        data = data.copy()
        if fullname is not None:
            d = pd.DataFrame({'full.name': data[fullname]})
            d['NLen'] = d['full.name'].str.len()  # 计算名字长度
            # 如果是复姓，取前两个字符, 否则取第一个字符
            d['sur.name'] = d['full.name'].apply(lambda x: x[:2] if (x[:2] in fuxing.values and len(x) > 2) else x[:1])
            d['given.name'] = d.apply(lambda row: row['full.name'][len(row['sur.name']):], axis=1)
        else:
            if surname is not None and givenname is not None:
                d = pd.DataFrame({'sur.name': data[surname], 'given.name': data[givenname]})
            elif surname is not None:
                d = pd.DataFrame({'sur.name': data[surname], 'given.name': ""})
            elif givenname is not None:
                d = pd.DataFrame({'sur.name': "", 'given.name': data[givenname]})
            d['full.name'] = d['sur.name'] + d['given.name']
            d['NLen'] = d['full.name'].str.len()

        d['name0'] = d['sur.name']  # 姓氏
        d['name1'] = d['given.name'].str[:1]  # 第一个字
        d['name2'] = d['given.name'].str[1:2]  # 第二个字
        d['name3'] = d['given.name'].str[2:3]  # 第三个字

        if birthyear is not None:
            d['year'] = data[birthyear]
        else:
            d['year'] = np.nan

        d = d[['name0', 'name1', 'name2', 'name3', 'year', 'NLen']]

        if log:
            print(f"Data preprocessed ({time.time() - t0:.4f} seconds).")

        ## Compute Indices ##
        if "SNU" in index:
            t0 = time.time()
            d['SNU'] = self.lookup(d, 'name0', familyname, 'surname', 'surname.uniqueness').round(digits)
            if log:
                print(f"SNU computed ({time.time() - t0:.4f} seconds).")

        if "SNI" in index:
            t0 = time.time()
            d['SNI'] = self.lookup(d, 'name0', familyname, 'surname', 'initial.rank')
            if log:
                print(f"SNI computed ({time.time() - t0:.4f} seconds).")

        if "NU" in index:
            t0 = time.time()
            d['nu1'] = self.compute_NU_char(d, ref_long, 'name1', 'year', NU_approx)
            d['nu2'] = self.compute_NU_char(d, ref_long, 'name2', 'year', NU_approx)
            d['nu3'] = self.compute_NU_char(d, ref_long, 'name3', 'year', NU_approx)
            d['NU'] = self.mean(d, 'nu', [1, 2, 3]).round(digits)
            if log:
                print(f"NU computed ({time.time() - t0:.4f} seconds).")

        if "CCU" in index:
            t0 = time.time()
            d['ccu1'] = self.lookup(d, 'name1', givenname, 'character', 'corpus.uniqueness')
            d['ccu2'] = self.lookup(d, 'name2', givenname, 'character', 'corpus.uniqueness')
            d['ccu3'] = self.lookup(d, 'name3', givenname, 'character', 'corpus.uniqueness')
            d['CCU'] = self.mean(d, 'ccu', [1, 2, 3]).round(digits)
            if log:
                print(f"CCU computed ({time.time() - t0:.4f} seconds).")

        if "NG" in index:
            t0 = time.time()
            d['ng1'] = self.lookup(d, 'name1', givenname, 'character', 'name.gender')
            d['ng2'] = self.lookup(d, 'name2', givenname, 'character', 'name.gender')
            d['ng3'] = self.lookup(d, 'name3', givenname, 'character', 'name.gender')
            d['NG'] = self.mean(d, 'ng', [1, 2, 3]).round(digits)
            if log:
                print(f"NG computed ({time.time() - t0:.4f} seconds).")

        if "NV" in index:
            t0 = time.time()
            d['nv1'] = self.lookup(d, 'name1', givenname, 'character', 'name.valence')
            d['nv2'] = self.lookup(d, 'name2', givenname, 'character', 'name.valence')
            d['nv3'] = self.lookup(d, 'name3', givenname, 'character', 'name.valence')
            d['NV'] = self.mean(d, 'nv', [1, 2, 3]).round(digits)
            if log:
                print(f"NV computed ({time.time() - t0:.4f} seconds).")

        if "NW" in index:
            t0 = time.time()
            d['nw1'] = self.lookup(d, 'name1', givenname, 'character', 'name.warmth')
            d['nw2'] = self.lookup(d, 'name2', givenname, 'character', 'name.warmth')
            d['nw3'] = self.lookup(d, 'name3', givenname, 'character', 'name.warmth')
            d['NW'] = self.mean(d, 'nw', [1, 2, 3]).round(digits)
            if log:
                print(f"NW computed ({time.time() - t0:.4f} seconds).")

        if "NC" in index:
            t0 = time.time()
            d['nc1'] = self.lookup(d, 'name1', givenname, 'character', 'name.competence')
            d['nc2'] = self.lookup(d, 'name2', givenname, 'character', 'name.competence')
            d['nc3'] = self.lookup(d, 'name3', givenname, 'character', 'name.competence')
            d['NC'] = self.mean(d, 'nc', [1, 2, 3]).round(digits)
            if log:
                print(f"NC computed ({time.time() - t0:.4f} seconds).")

        if return_namechar:
            data = pd.concat([data, d[['name0', 'name1', 'name2', 'name3']]], axis=1)
        data_new = pd.concat([data, d[index]], axis=1)
        if return_all:
            return d
        else:
            return data_new

if __name__ == '__main__':
    print('test..')
    cn = ChineseNames()
    result = cn.compute_name_index(name=["包寒吴霜"], birth=[2023])
    print(result.values)
    result = cn.compute_name_index(name=["包寒吴霜"], birth=[1995])
    print(result.values)
    result = cn.compute_name_index(name=["包寒吴霜", "陈俊霖", "张伟", "张炜", "欧阳修", "欧阳", "易烊千玺", "张艺谋", "王的"],
                                birth=[1995, 1995, 1985, 1988, 1968, 2009, 2000, 1950, 2005])
    print(result.values)
    #   '包寒吴霜' 1995 '包' '寒' '吴' '霜'    4 3.0600  2 3.6042 4.1173 -0.2190 3.3542 2.6667 3.2333
    # 1: 包寒吴霜  1995  包   寒   吴   霜     4 3.0595  2 3.6042 4.1178 -0.2187 3.3542 2.6667 3.2333
    # 数据NU，CCU，NG有部分数据约减后与示例相同，估计是数据源精确度不同导致的
