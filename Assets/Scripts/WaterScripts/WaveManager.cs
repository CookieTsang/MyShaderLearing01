//WaveManager����һ������Ч�������Ч��ʵ���ϲ��ɼ�
//����ˮ�沨�˸߶ȣ��ṩ��������

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveManager : MonoBehaviour
{
    public static WaveManager instance;
    public float amplitude = 1f;//��������沨��
    public float length = 2f;//����
    public float wide = 2f;//���
    public float speed = 1f;//����
    public float offset = 0f;//ƫ����(ʵʱ�仯)

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else if (instance != this)
        {
            Debug.Log("ʵ���Ѿ�����");
        }
    }

    private void Update()
    {
        offset += Time.deltaTime * speed;//����ƫ��

    }
    public float GetWaveHeight(float _x, float _z)
    {
        return amplitude * Mathf.Sin(_x / length + offset) * Mathf.Sin(_z / wide + offset);
        //������� _x �� _z ����Ĳ���ֵ���������ֵ������λ�õĲ�ͬ���仯
        //ͨ������ amplitude, length, wide, offset ���ı䲨����״��λ��
    }
 

}

//?	public:�����˼��������ĸ����ͱ����������� Unity �༭�������ò��˵���������� (amplitude)������ (length)����� (wide)���ٶ� (speed) ��ƫ���� (offset)��
//?	����ƫ�������� Update �����У�����ʱ������ (Time.deltaTime) ���趨���ٶ� (speed) ���²�����ƫ���� (offset)��
//?	���㲨���߶ȣ�GetWaveHight ���������������� _x �� _z������ռ��е�����ֵ���÷������ض�Ӧλ���ϵĲ����߶ȡ�
//?	�����߶�ͨ�� amplitude �Ŵ������Һ����Һ�����ϼ���ó����������Һ��������� _x ����� length�����Һ��������� _z ����� wide�����߶������� offset ��ģ�Ⲩ����ʱ��ı仯��
//? �ܽ᣺����һ������ʱ��Ϳռ�����Ĳ���Ч��������Ӧ����ˮ�沨�����������Ƴ�����