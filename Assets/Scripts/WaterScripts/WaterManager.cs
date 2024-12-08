//WaterManager����������ˮ��������εģ�ͨ������ÿ�������λ����ģ��ˮ�沨��Ч��
//?	�����е� Update ����ÿ֡���ᱻ���ã����ڸ�������Ķ���λ�á�
//?	ͨ�� WaveManager �� GetWaveHeight ������ȡÿ��������¸߶ȣ������¶������顣
//?	���º��������� mesh.vertices �����¼��㷨����ȷ��������ȷ��

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]

public class WaterManager : MonoBehaviour
{
    private MeshFilter meshFilter;

    //Awake������Unity�������ڵ�һ���֣�����Ϸ��������ʱ���á��˷����ڳ�������ʱ���ȱ����á�
    //GetComponent<MeshFilter>()����ȡ��ǰGameObject�ϵ�MeshFilter�������ֵ��meshFilter����

    private void Awake()//���ȵ���
    {
        meshFilter = GetComponent<MeshFilter>();
    }

    private void Update()
    {
        Vector3[] vertices = meshFilter.mesh.vertices; //��ȡ��ǰ����Ķ������飬����ΪVector3[]����ά�������飩��
        for (int i = 0; i < vertices.Length; i++)
        {
            vertices[i].y = WaveManager.instance.GetWaveHeight(transform.position.x + vertices[i].x, transform.position.z + vertices[i].z);
         
   

        }
        //ѭ������ÿ�����㣺ʹ��һ��forѭ���������ж��㡣
        //����y���꣺
        //ʹ�ü�����ڵ�WaveManagerʵ���е�GetWaveHeight���������µ�yֵ�����������������������
        //transform.position.x + vertices[i].x������ǰ�����x����������xλ����ӣ��������������������x��
        //transform.position.z + vertices[i].z���������������������z��
        //GetWaveHeight�����ض�λ�õĲ��ĸ߶ȣ����ֵ������Ϊ��ǰ�������y���ꡣ
        //������������:
        meshFilter.mesh.vertices = vertices;
        meshFilter.mesh.RecalculateNormals();

    }
}